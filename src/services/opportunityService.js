const opportunities = [
  {
    id: "opp-001",
    agency: "GSA",
    title: "Identity Verification Modernization",
    stage: "triage",
    owner: "delivery-lead"
  },
  {
    id: "opp-002",
    agency: "VA",
    title: "Case Intake Experience Upgrade",
    stage: "discovery",
    owner: "product-manager"
  }
];

export function listOpportunities() {
  return opportunities;
}

export function createOpportunity(candidate) {
  const requiredFields = ["agency", "title", "stage", "owner"];
  const missingField = requiredFields.find((field) => !candidate[field]);

  if (missingField) {
    return {
      ok: false,
      error: `Missing required field: ${missingField}`
    };
  }

  const nextId = `opp-${String(opportunities.length + 1).padStart(3, "0")}`;
  const record = {
    id: nextId,
    agency: candidate.agency,
    title: candidate.title,
    stage: candidate.stage,
    owner: candidate.owner
  };

  opportunities.push(record);

  return {
    ok: true,
    value: record
  };
}
