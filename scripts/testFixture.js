#!/usr/bin/env node
const fs = require("fs");
const fsp = fs.promises;
const path = require("path");
const { execSync } = require("child_process");

async function main() {
  const slug = process.argv[2];
  if (!slug) {
    console.error("Usage: node scripts/testFixture.js <assignment-slug>");
    process.exit(1);
  }

  const root = path.join(__dirname, "..");
  const assignmentRoot = path.join(root, "assignments", slug);
  const projectRoot = path.join(assignmentRoot, "project");
  const solutionRoot = path.join(assignmentRoot, "solution");
  const hiddenTestsRoot = path.join(assignmentRoot, "hidden-tests");

  for (const p of [assignmentRoot, projectRoot, solutionRoot, hiddenTestsRoot]) {
    if (!fs.existsSync(p)) {
      console.error(`Missing required path: ${p}`);
      process.exit(1);
    }
  }

  const tmpBase = path.join(root, ".tmp-fixtures");
  await fsp.mkdir(tmpBase, { recursive: true });
  const tmpDir = await fsp.mkdtemp(path.join(tmpBase, `${slug}-`));

  await copyDir(projectRoot, tmpDir);
  await copyDir(hiddenTestsRoot, path.join(tmpDir, "test"));
  // Overlay solution contracts into the temp project
  await copyDir(path.join(solutionRoot, "src"), path.join(tmpDir, "src"));

  console.log(`Temp fixture at: ${tmpDir}`);
  run("forge install", tmpDir);
  run("forge test", tmpDir);
}

function run(cmd, cwd) {
  console.log(`> ${cmd}`);
  execSync(cmd, { cwd, stdio: "inherit" });
}

async function copyDir(src, dest) {
  await fsp.mkdir(dest, { recursive: true });
  await fsp.cp(src, dest, { recursive: true, force: true });
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
