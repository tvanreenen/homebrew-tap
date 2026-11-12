"""Check the final tap redirect without contacting GitHub or publishing."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class MigrationTests(unittest.TestCase):
    def test_destination_and_retained_packages(self):
        migrations = json.loads((ROOT / "tap_migrations.json").read_text())
        self.assertEqual(migrations, {name: "tvr-works/tap" for name in
                                     ["frame", "key", "key@alpha", "key@beta", "xkcdpass"]})
        self.assertFalse((ROOT / "Formula/xkcdpass.rb").exists())
        self.assertFalse((ROOT / "Casks/frame.rb").exists())

    def test_moved_publishers_fail_before_github_access(self):
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            fake = directory / "gh"
            fake.write_text("#!/bin/sh\necho 'unexpected GitHub access' >&2\nexit 99\n")
            fake.chmod(0o755)
            env = dict(os.environ, PATH=f"{directory}:{os.environ['PATH']}")
            for package in ["frame", "key", "xkcdpass"]:
                result = subprocess.run([str(ROOT / ".github/scripts/prepare-package-update.sh"),
                                         package, "v0.2.1", str(directory / "outputs")],
                                        env=env, text=True, capture_output=True)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("publication has moved", result.stderr)
                self.assertNotIn("unexpected GitHub access", result.stderr)
                self.assertFalse((directory / "outputs").exists())


if __name__ == "__main__":
    unittest.main()
