# External Repo Flow

This is someone else's repo. Review it remotely — do NOT clone or download.

1. **Fetch repo info** (in parallel via `gh` CLI):
   - `gh repo view <owner/repo>`
   - `gh api repos/<owner/repo> --jq '{stars: .stargazers_count, forks: .forks_count, issues: .open_issues_count, updated: .updated_at, archived: .archived, license: .license.spdx_id, topics: .topics}'`
   - `gh api repos/<owner/repo>/readme --jq .content | base64 -d` (README)
   - `gh api repos/<owner/repo>/contents` (top-level files)
   - `gh api repos/<owner/repo>/languages`

2. **Dig deeper**:
   - Fetch `package.json` / `Cargo.toml` / `pyproject.toml` for dependencies
   - Check recent commits: `gh api repos/<owner/repo>/commits --jq '.[0:5] | .[] | {date: .commit.author.date, msg: .commit.message}'`
   - Glance at src/ or lib/ directory structure

3. **Present the review**:
   - **What it is** — one sentence
   - **Tech stack** — language, framework, dependencies
   - **Health signals** — stars, activity, open issues, last commit, archived?
   - **License** — commercial use compatible?
   - **Code quality impression** — structure, README quality, dependency choices
   - **Verdict** — honest assessment. Worth using? Red flags? Alternatives?

4. **Offer options**:
   - **Fork it** — `gh repo fork <owner/repo> --clone=false`
   - **Clone it** — clone to `~/Projects/<name>` for deeper exploration
   - **Star it** — `gh api user/starred/<owner/repo> -X PUT`
   - **Deeper dive** — read more source files
   - **Pass** — move on

Wait for the user to pick before doing anything.
