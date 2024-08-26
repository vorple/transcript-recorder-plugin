import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig({
    build: {
        lib: {
            entry: resolve(__dirname, "src/transcript-recorder.js"),
            name: "Vorple Transcript Recorder Plugin",
            fileName: "transcript-recorder.min"
        }
    }
});
