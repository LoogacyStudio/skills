# Run record finalization checklist

Use this checklist when an executed run was reserved in a `-scaffold.md` slot and now needs to become a canonical completed run record.

This checklist belongs primarily to `benchmark-judge-run`.

## When to finalize

Finalize when all of the following are true:

- execution is complete
- route result is judged
- five-dimension scoring is present
- failure tags are attached or explicitly `none`
- invariance / robustness notes are present when relevant
- the record is ready to be cited by clustering or candidate review work

Do **not** finalize when the file is still just a reserved slot or when critical judging fields remain pending.

## Finalization actions

1. **Replace placeholder status with judged status**
   - remove remaining `pending` fields
   - ensure the record reads as `completed`

2. **Promote the filename if needed**
   - rename `RUN-...-scaffold.md` -> `RUN-....md` once the judged record is real
   - preserve the same benchmark ID, path, and date unless the repo convention explicitly requires a different final name

3. **Update direct pair links**
   - fix paired skill/worker or baseline/variant links that still point to scaffold names

4. **Update in-scope citations**
   - rerun manifest indexes
   - candidate review evidence lists
   - nearby README or run-family inventory notes
   - repo memories or notes if they cite the old scaffold path

5. **Remove obsolete scaffold copies**
   - delete the old scaffold-named file once the finalized record exists and references are updated

## Scope discipline

Apply only the smallest citation cleanup needed to prevent evidence-chain breakage.

Good cleanup:

- paired rerun records
- the active rerun manifest
- the active candidate review
- directly affected README notes

Avoid scope sprawl:

- rewriting unrelated historical evidence
- mass-editing benchmark prose that only happens to mention the word `pending`
- expanding into new rerun planning or candidate review logic that was not part of the completed run

## Red flags

Stop and reassess if:

- multiple conflicting final filenames seem plausible
- the run record is complete but the judged route is still disputed
- updating citations would expand into a broad corpus rewrite rather than a local evidence sync
- the old scaffold file contains materially different content from the new finalized version

## Handoff rule

After finalization:

- `benchmark-cluster-failures` should consume the finalized run record
- `benchmark-review-candidate` should cite the finalized run record
- rerun manifests may still mention scaffold naming generically, but active direct links should point at the finalized record
