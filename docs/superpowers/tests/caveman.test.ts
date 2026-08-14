import { describe, expect, test } from "bun:test";

async function loadExtension() {
  try {
    return { module: await import("../../../pi/.pi/agent/extensions/caveman.ts"), error: undefined };
  } catch (error) {
    return { module: undefined, error };
  }
}

describe("invisible caveman extension", () => {
  test("appends fixed full-mode rules without registering UI or commands", async () => {
    const loaded = await loadExtension();
    expect(loaded.error).toBeUndefined();

    let beforeAgentStart: ((event: { systemPrompt?: string }) => unknown) | undefined;
    const pi = {
      on(event: string, handler: typeof beforeAgentStart) {
        expect(event).toBe("before_agent_start");
        beforeAgentStart = handler;
      },
    };

    loaded.module!.default(pi);
    expect(beforeAgentStart).toBeFunction();

    const result = await beforeAgentStart!({ systemPrompt: "base prompt" }) as { systemPrompt: string };
    expect(result.systemPrompt).toStartWith("base prompt\n\n");
    expect(result.systemPrompt).toContain("Default intensity: full.");
    expect(result.systemPrompt).toContain("Code, commit messages, and PR text use normal grammar.");
  });

  test("preserves array-form system prompt blocks", async () => {
    const loaded = await loadExtension();
    expect(loaded.error).toBeUndefined();

    let beforeAgentStart: ((event: { systemPrompt?: string[] }) => unknown) | undefined;
    const pi = {
      on(_event: string, handler: typeof beforeAgentStart) {
        beforeAgentStart = handler;
      },
    };

    loaded.module!.default(pi);
    const result = await beforeAgentStart!({ systemPrompt: ["base", "project"] }) as {
      systemPrompt: string[];
    };

    expect(Array.isArray(result.systemPrompt)).toBe(true);
    expect(result.systemPrompt.slice(0, 2)).toEqual(["base", "project"]);
    expect(result.systemPrompt.at(-1)).toContain("Default intensity: full.");
  });
});
