import type {
  BeforeAgentStartEventResult,
  ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

const FULL_PROMPT = `IMPORTANT: CAVEMAN MODE applies to every response.

Default intensity: full.

- Maximum compression while preserving all technical substance.
- Drop articles, filler, pleasantries, hedging, and redundant restatement.
- Fragments allowed. Prefer short words. Keep technical terms and quoted errors exact.
- Prefer tables over prose. Use pattern: [thing] [action] [reason]. [next step].
- Code, commit messages, and PR text use normal grammar.
- For security warnings, irreversible actions, or ordered steps where fragments risk ambiguity: use explicit full sentences, then resume full Caveman style.

Before sending each response, compress it again. If same meaning fits fewer words, use fewer words.`;

function appendSystemPrompt(systemPrompt: unknown): string | string[] {
  if (Array.isArray(systemPrompt)) return [...systemPrompt, FULL_PROMPT];
  return typeof systemPrompt === "string" && systemPrompt
    ? `${systemPrompt}\n\n${FULL_PROMPT}`
    : FULL_PROMPT;
}

export default function caveman(pi: ExtensionAPI) {
  pi.on("before_agent_start", (event) => ({
    systemPrompt: appendSystemPrompt(event.systemPrompt),
  }) as unknown as BeforeAgentStartEventResult);
}
