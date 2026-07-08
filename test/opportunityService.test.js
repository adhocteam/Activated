import test from "node:test";
import assert from "node:assert/strict";

import { createOpportunity, listOpportunities } from "../src/services/opportunityService.js";

test("listOpportunities returns seeded records", () => {
  const records = listOpportunities();

  assert.ok(Array.isArray(records));
  assert.ok(records.length >= 2);
});

test("createOpportunity validates required fields", () => {
  const result = createOpportunity({ title: "Missing fields" });

  assert.equal(result.ok, false);
  assert.match(result.error, /Missing required field/);
});

test("createOpportunity appends valid record", () => {
  const result = createOpportunity({
    agency: "USCIS",
    title: "Caseworker Workflow Replatform",
    stage: "delivery",
    owner: "eng-manager"
  });

  assert.equal(result.ok, true);
  assert.equal(result.value.agency, "USCIS");
  assert.equal(result.value.id, "opp-003");
});
