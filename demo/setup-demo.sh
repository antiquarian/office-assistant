#!/bin/bash
# setup-demo.sh — Pre-Built Office Assistant Demo Setup
# Creates a demo workspace at ~/.openclaw/workspace-demo/
# Persona: Jordan Lee, owner of Greenleaf Consulting

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEMO_DIR="$HOME/.openclaw/workspace-demo"
SKILLS_DIR="$PROJECT_ROOT/skills"

echo "Setting up demo workspace at $DEMO_DIR..."

# Clean slate
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"/{crm/{clients,vendors,projects},tasks,documents/{drafts,templates},skills,memory}

# ── Persona files ─────────────────────────────────────────────────────────────

cat > "$DEMO_DIR/SOUL.md" << 'EOF'
# SOUL.md - Assistant Persona

You are Alex, a professional AI assistant for Greenleaf Consulting.

## Core Identity
- **Name:** Alex
- **Vibe:** Professional, warm, efficient. Like a sharp EA who knows the business.
- **Tone:** Concise and direct. No filler phrases. No "Great question!"
- **Focus:** Help Jordan run Greenleaf Consulting with less friction.

## Behavior
- Be proactive: surface things Jordan should know.
- Be resourceful: try to figure things out before asking.
- Be careful: ask before sending emails or deleting anything.
EOF

cat > "$DEMO_DIR/USER.md" << 'EOF'
# USER.md - About Jordan

- **Name:** Jordan Lee
- **Company:** Greenleaf Consulting
- **Role:** Owner / Principal Consultant
- **Timezone:** America/Chicago
- **Email:** jordan@greenleafconsulting.com
- **Notes:** Prefers concise updates. Hates status meetings. Loves when things just work.
EOF

# ── CRM: Clients ──────────────────────────────────────────────────────────────

cat > "$DEMO_DIR/crm/clients/acme-solutions.md" << 'EOF'
# Acme Solutions

- **Contact:** Sarah Park (sarah@acmesolutions.com)
- **Status:** Active
- **Since:** 2026-01-15
- **Last Contact:** 2026-05-01

## Notes
AI workflow automation engagement. 3-month project starting March 2026.
Primary focus: automating their RFP response process.

## Interaction Log
- 2026-05-01: Monthly check-in call — project on track, Phase 2 kicking off next week
- 2026-04-15: Delivered Phase 1 workflow audit report — Sarah very happy with results
- 2026-03-01: Project kickoff meeting
- 2026-01-20: Proposal signed and returned
- 2026-01-15: Initial discovery call
EOF

cat > "$DEMO_DIR/crm/clients/riverside-group.md" << 'EOF'
# Riverside Group

- **Contact:** Marcus Webb (mwebb@riversidegroup.com)
- **Status:** Active
- **Since:** 2026-03-01
- **Last Contact:** 2026-04-22

## Notes
Operations consulting engagement. Focus on reporting automation and staff scheduling.
Marcus is detail-oriented — always wants numbers.

## Interaction Log
- 2026-04-22: Sent monthly status report — Marcus requested a demo of the new dashboard next call
- 2026-04-01: Delivered automated reporting prototype — well received
- 2026-03-10: Discovery session with Marcus and his ops team
- 2026-03-01: Engagement signed
EOF

cat > "$DEMO_DIR/crm/clients/northgate-partners.md" << 'EOF'
# Northgate Partners

- **Contact:** Diana Chen (dchen@northgatepartners.com)
- **Status:** Prospect
- **Since:** 2026-04-28
- **Last Contact:** 2026-04-28

## Notes
Law firm interested in AI-assisted document review and client intake.
Diana is the managing partner. Very cautious about data security.
Proposal sent — awaiting response.

## Interaction Log
- 2026-04-28: Discovery call with Diana — sent proposal same day
- 2026-04-20: Cold outreach via LinkedIn, Diana responded positively
EOF

# ── CRM: Vendors ──────────────────────────────────────────────────────────────

cat > "$DEMO_DIR/crm/vendors/cloudprint-co.md" << 'EOF'
# CloudPrint Co

- **Contact:** billing@cloudprint.com
- **Status:** Active vendor
- **Since:** 2026-02-01
- **Last Contact:** 2026-04-01

## Notes
Document printing and mailing vendor. Used for client deliverable packages.
Net-30 payment terms.

## Interaction Log
- 2026-04-01: Renewed annual contract
EOF

cat > "$DEMO_DIR/crm/vendors/techstack-hosting.md" << 'EOF'
# TechStack Hosting

- **Contact:** support@techstackhosting.com
- **Status:** Active vendor
- **Since:** 2025-09-01
- **Last Contact:** 2026-03-15

## Notes
Cloud hosting for client deliverable portals. $149/month.
Renewal due September 2026.

## Interaction Log
- 2026-03-15: Upgraded plan to support Acme project portal
EOF

# ── CRM: Projects ─────────────────────────────────────────────────────────────

cat > "$DEMO_DIR/crm/projects/acme-rfp-automation.md" << 'EOF'
# Acme RFP Automation

- **Client:** Acme Solutions
- **Status:** Active — Phase 2
- **Start:** 2026-03-01
- **Last Updated:** 2026-05-01

## Description
Automating Acme's RFP response workflow. Phase 1 (audit) complete.
Phase 2: building the answer library and draft generation system.

## Open Items
- Finalize answer library content with Sarah's team (due May 10)
- Demo draft generation to stakeholders (due May 20)
- Phase 2 status report due May 15

## Log
- 2026-05-01: Phase 2 kickoff — team aligned on timeline
- 2026-04-15: Phase 1 audit delivered and accepted
- 2026-03-01: Project started
EOF

cat > "$DEMO_DIR/crm/projects/riverside-reporting.md" << 'EOF'
# Riverside Reporting Automation

- **Client:** Riverside Group
- **Status:** Active
- **Start:** 2026-03-10
- **Last Updated:** 2026-04-22

## Description
Automating Riverside's weekly and monthly operational reports.
Integrating with their existing data sources (QuickBooks, Google Sheets).

## Open Items
- Schedule dashboard demo with Marcus (target: week of May 6)
- Finalize staff scheduling module design

## Log
- 2026-04-22: Marcus requested dashboard demo — scheduling next call
- 2026-04-01: Reporting prototype delivered
- 2026-03-10: Discovery session complete, scope defined
EOF

# ── Snapshot files for demo ───────────────────────────────────────────────────

cat > "$DEMO_DIR/calendar-snapshot.md" << 'EOF'
# Calendar Snapshot — Week of May 5, 2026

## Monday May 5
- 10:00 AM — Acme Solutions check-in (Sarah Park) · Teams · 30 min

## Tuesday May 6
- 2:00 PM — Riverside Group demo prep call (Marcus Webb) · Zoom · 45 min

## Wednesday May 7
- 11:00 AM — Northgate Partners follow-up (Diana Chen) · Phone · 30 min
- 3:00 PM — Greenleaf team standup · Internal · 30 min

## Thursday May 8
- 9:00 AM — Vendor review: TechStack Hosting contract renewal · Internal

## Friday May 9
- Free — deep work day
EOF

cat > "$DEMO_DIR/inbox-snapshot.md" << 'EOF'
# Inbox Snapshot — May 5, 2026

## Unread / Needs Action

1. **Sarah Park (Acme Solutions)** — "Re: Phase 2 kickoff"
   Confirming May 10 deadline for answer library content. Asks if we can move the stakeholder demo to May 22 instead of May 20.

2. **Marcus Webb (Riverside Group)** — "Dashboard demo"
   Available May 7 or May 8 for the dashboard demo. Prefers morning.

3. **Diana Chen (Northgate Partners)** — "Greenleaf proposal — a few questions"
   Liked the proposal. Has 3 questions about data security and pricing. Wants to talk this week.

## FYI / No Action Needed

4. **TechStack Hosting** — "Your invoice is ready — April 2026"
   $149.00 due May 15.

5. **LinkedIn** — "Marcus Webb viewed your profile"

6. **CloudPrint Co** — "Order #4821 shipped"
   Acme deliverable package shipped, estimated delivery May 6.
EOF

# ── Tasks ─────────────────────────────────────────────────────────────────────

cat > "$DEMO_DIR/tasks/today.md" << 'EOF'
# 2026-05-05

## Must do
- [ ] Reply to Diana Chen — address her security and pricing questions
- [ ] Confirm dashboard demo time with Marcus (May 7 or 8 AM)

## Should do
- [ ] Draft Phase 2 status report for Acme (due May 15)
- [ ] Review TechStack invoice ($149 due May 15)

## Waiting / blocked
- [ ] Northgate Partners proposal — awaiting Diana's decision
- [ ] Acme answer library content — Sarah's team delivering May 10
EOF

# ── Copy bundled skills ──────────────────────────────────────────────────────

copy_skill() {
  local skill_name="$1"
  if [ -d "$SKILLS_DIR/$skill_name" ]; then
    cp -r "$SKILLS_DIR/$skill_name" "$DEMO_DIR/skills/"
    echo "✓ $skill_name skill copied"
  else
    echo "⚠ $skill_name skill not found in project bundle"
  fi
}

copy_skill "crm-lite"
copy_skill "document-assistant"
copy_skill "email-assistant"
copy_skill "calendar-assistant"

# Copy document templates into workspace documents/templates/ so the skill can find them
if [ -d "$SKILLS_DIR/document-assistant/templates" ]; then
  cp "$SKILLS_DIR/document-assistant/templates/"*.md "$DEMO_DIR/documents/templates/"
  echo "✓ document templates copied to workspace"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "✅ Demo workspace ready at: $DEMO_DIR"
echo ""
echo "Persona: Jordan Lee, Greenleaf Consulting"
echo "Clients: Acme Solutions (active), Riverside Group (active), Northgate Partners (prospect)"
echo "Projects: Acme RFP Automation (Phase 2), Riverside Reporting Automation"
echo ""
echo "To run a demo session, point OpenClaw at the demo workspace."
echo "To tear down: bash demo/teardown-demo.sh"
