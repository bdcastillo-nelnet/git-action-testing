# git-action-testing

A learning project for AWS static-site hosting and CI/CD with GitHub Actions.

## Structure

```
.
├── infra/      # Terraform — S3, CloudFront, DynamoDB, IAM (run terraform here)
├── web/        # React frontend (Vite)
├── backend/    # Lambda functions (Node.js) — reads/writes DynamoDB
└── .github/
    └── workflows/
        ├── aws-check.yml         # manual: verify GitHub can auth to AWS
        └── terraform-deploy.yml  # validate on PR, apply on push to main
```

Each top-level folder is an independent deploy target:

| Folder     | What it is        | Deployed by                    |
|------------|-------------------|--------------------------------|
| `infra/`   | Terraform config  | `terraform-deploy.yml`         |
| `web/`     | React static site | (uploaded to S3 — see infra)   |
| `backend/` | Lambda functions  | (not wired up yet)             |

## Working locally

```bash
# Infrastructure
cd infra && terraform init && terraform plan

# Frontend
cd web && npm install && npm run dev

# Backend
cd backend && npm install
```

## Notes / TODO

- Terraform still uses **local state** — add an S3 remote backend before relying on CI apply.
- `infra/iam.tf` and `infra/outputs.tf` reference a Lambda (`lambda_role`, `get_user`)
  that isn't defined yet — finish the backend infra or remove those references.
- The React app must be **built** (`npm run build`) and its `dist/` uploaded to S3;
  the current `infra/s3.tf` only uploads a single `index.html`.
