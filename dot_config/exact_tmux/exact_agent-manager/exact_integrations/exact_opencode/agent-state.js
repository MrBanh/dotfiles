// agent-manager opencode integration.
//
// Reports opencode's live state to the tmux pane it runs in:
//   - sets the pane option @agent_state (working | idle | waiting | error)
//   - appends events to a per-pane activity log the popup shows
//   - asks agent-manager to fire a notification on done / needs-input / error
//
// tmux exposes $TMUX_PANE to every process in a pane, so we know which pane to
// tag — no socket, no daemon. Auto-loaded by opencode from
// ~/.config/opencode/plugins/ (symlinked there by `agent-manager install`).
import { execFile } from "node:child_process";
import { appendFileSync, mkdirSync } from "node:fs";

const PANE = process.env.TMUX_PANE;
const ACT_DIR = `${process.env.TMPDIR || "/tmp"}/agent-manager/activity`;

// Track the last state we wrote so @agent_state_ts marks each *transition* (not
// every event). That's what lets the picker show "how long in THIS state" (how long
// working, how long idle), like tmux-agent-sidebar — rather than time-per-event.
let lastState = null;
function setState(state) {
  if (!process.env.TMUX || !PANE) return;
  execFile(
    "tmux",
    ["set-option", "-p", "-t", PANE, "@agent_state", state],
    () => {},
  );
  if (state !== lastState) {
    lastState = state;
    const ts = String(Math.floor(Date.now() / 1000));
    execFile(
      "tmux",
      ["set-option", "-p", "-t", PANE, "@agent_state_ts", ts],
      () => {},
    );
  }
}

// One activity row per line, pipe-delimited: "HH:MM:SS|tool|detail". The picker
// parses and colorizes it (tool name → stable color). Keeping the log raw (no
// ANSI, no icons) means presentation lives entirely in the renderer.
function logActivity(tool, detail = "") {
  if (!PANE) return;
  try {
    mkdirSync(ACT_DIR, { recursive: true });
    const t = new Date().toTimeString().slice(0, 8);
    const d = String(detail)
      .replace(/[\r\n|]+/g, " ")
      .trim();
    appendFileSync(`${ACT_DIR}/${PANE}.log`, `${t}|${tool}|${d}\n`);
  } catch {}
}

// A short human target for a tool call, so the log reads "bash  npm test" /
// "edit  agent-state.js" instead of a bare "bash". opencode passes the tool's
// arguments in the second hook param (output.args).
function activityDetail(args) {
  if (!args || typeof args !== "object") return "";
  let d = "";
  if (args.command) d = args.command;
  else if (args.filePath) d = String(args.filePath).split("/").pop();
  else if (args.pattern) d = args.pattern;
  else if (args.url) d = args.url;
  else if (args.description) d = args.description;
  d = String(d).replace(/\s+/g, " ").trim();
  if (d.length > 48) d = d.slice(0, 47) + "…";
  return d;
}

// Ask agent-manager (path stored in the tmux option @agent_manager_bin) to fire
// a notification, honoring the user's notify/sound settings.
function notify(state) {
  if (!process.env.TMUX || !PANE) return;
  const sh =
    'b="$(tmux show -gv @agent_manager_bin 2>/dev/null)"; [ -n "$b" ] && exec "$b" notify "$1" opencode "$2"';
  execFile("sh", ["-c", sh, "am", PANE, state], () => {});
}

export const AgentManagerState = async () => {
  if (!process.env.TMUX || !process.env.TMUX_PANE) return {};

  setState("idle");
  logActivity("started");

  const childSessions = new Set();

  return {
    "chat.message": async ({ sessionID }) => {
      if (sessionID && childSessions.has(sessionID)) return;
      setState("working");
    },
    "tool.execute.before": async (input, output) => {
      setState("working");
      logActivity(input?.tool ?? "tool", activityDetail(output?.args));
    },
    event: async ({ event }) => {
      const type = event?.type;
      const props = event?.properties ?? {};
      const sessionID =
        typeof props.sessionID === "string" ? props.sessionID : undefined;

      const info = props.info;
      if (info?.id && info.parentID) childSessions.add(info.id);

      if (sessionID && childSessions.has(sessionID)) {
        if (type === "permission.asked" || type === "question.asked") {
          setState("waiting");
          logActivity("waiting", "subagent");
          notify("waiting");
        } else if (
          type === "permission.replied" ||
          type === "question.replied" ||
          type === "question.rejected"
        ) {
          setState("working");
        }
        return;
      }

      switch (type) {
        case "permission.replied":
        case "question.replied":
        case "question.rejected":
        case "session.compacted":
          setState("working");
          break;
        case "permission.asked":
        case "question.asked":
          setState("waiting");
          logActivity("waiting", "needs your input");
          notify("waiting");
          break;
        case "session.error":
          setState("error");
          logActivity("error");
          notify("error");
          break;
        case "session.idle":
          setState("idle");
          notify("idle");
          break;
        case "session.status": {
          const kind =
            typeof props.status === "string"
              ? props.status
              : props.status?.type;
          if (typeof kind === "string") {
            const k = kind.toLowerCase();
            if (k === "idle") setState("idle");
            else if (
              [
                "busy",
                "active",
                "pending",
                "running",
                "streaming",
                "working",
                "retry",
              ].includes(k)
            )
              setState("working");
          }
          break;
        }
        default:
          break;
      }
    },
  };
};
