# Dayoffly v0.0.1

Playful Lifestyle web app for Greek public holidays and optimized time off planning. No backend required for the initial release.

## Features
- Responsive Greek/English dashboard, calendar and leave optimizer
- Greek nationwide statutory public holiday calendar (with computed Orthodox Easter), years 2025–2035
- Custom workdays, leave budget, date exclusions and region hints
- Personalized leave recommendations, manual planner, favorite plans
- Saved plans, ICS export, sharing, offline-installable PWA shell
- All profile data stays in this browser's localStorage

## Development
Open `index.html` in a browser or serve this directory using `python -m http.server 8080`. A web server is recommended for PWA support.

## Deploy
GitHub Pages action deploys the repository root on push to `main`. In repository Settings → Pages select **GitHub Actions** as the build and deployment source. Configure your DNS registrar with GitHub Pages apex A records: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`, plus optional `www` CNAME pointing to `Donacgreece.github.io`. Add `dayoffly.app` as your custom domain in Pages and enable HTTPS once verification succeeds. DNS records can change; validate against current GitHub documentation.

## Limitations
Holiday information and leave recommendations are for personal planning. Employer-specific regulations, sector rules, local holidays, actual paid-leave entitlement, and shift rosters must be confirmed independently. Business approvals, accounts, live travel bookings, push notifications and cloud sync are not implemented in v0.0.1.
