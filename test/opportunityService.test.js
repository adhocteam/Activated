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

test("createOpportunity rejects unknown fields", () => {
  const countBefore = listOpportunities().length;
  const result = createOpportunity({
    agency: "GSA",
    title: "Login.gov Rollout",
    stage: "triage",
    owner: "product-manager",
    priority: "high"
  });

  assert.equal(result.ok, false);
  assert.equal(result.error, "Unknown field: priority");
  assert.equal(listOpportunities().length, countBefore);
});

test("createOpportunity lists every unknown field", () => {
  const result = createOpportunity({
    id: "opp-999",
    agency: "GSA",
    title: "Login.gov Rollout",
    stage: "triage",
    owner: "product-manager",
    priority: "high"
  });

  assert.equal(result.ok, false);
  assert.equal(result.error, "Unknown fields: id, priority");
});

test("createOpportunity reports unknown fields before missing ones", () => {
  const result = createOpportunity({ title: "Partial", notes: "extra" });

  assert.equal(result.ok, false);
  assert.equal(result.error, "Unknown field: notes");
});
