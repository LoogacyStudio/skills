# Repo skill asset — Variant Bundle Template

Canonical policy context: the active benchmark corpus variant-family catalog and taxonomy doc.

Use this asset as the final output skeleton when authoring benchmark variants.

```md
## Base benchmark context

- **Benchmark ID:** <B001>
- **Benchmark title:** <short title>
- **Task family:** <T1-T5>
- **Base suite coverage:** <suite names>
- **Expected artifact type:** <artifact type>
- **Base route expectation:** <R1-R6 or allowed alternates>
- **Why variants are being created now:** <one sentence>

## Variant strategy

- **Variant mode in scope:** <metamorphic | adversarial | mixed>
- **Families selected:** <M1-M5 / A1-A6>
- **Why these families were chosen:** <short rationale>
- **What should remain invariant or fail safely:** <summary>
- **What should not be over-inferred from this bundle:** <summary>

## variant_bundle

1. **Variant record 1**
   - **Variant ID:** <id>
   - **Variant type:** <metamorphic | adversarial>
   - **Family:** <M1-M5 | A1-A6>
   - **Purpose:** <one sentence>
   - **Main transformation or stressor:** <one sentence>
   - **Route expectation:** <same as base | alternate accepted | intentionally stressed>
   - **Expected invariant or safe-failure rule:** <one sentence>
   - **Hard invariants:**
     - <invariant>
     - <invariant>
   - **Soft invariants:**
     - <invariant>
     - <invariant>
   - **Allowed drift budget:**
     - <rule>
     - <rule>
   - **Transformed input package:** <execution-ready input>
   - **Notes for runner / judge:** <short notes>
2. **Variant record 2**
   - **Variant ID:** <id>
   - **Variant type:** <metamorphic | adversarial>
   - **Family:** <M1-M5 | A1-A6>
   - **Purpose:** <one sentence>
   - **Main transformation or stressor:** <one sentence>
   - **Route expectation:** <same as base | alternate accepted | intentionally stressed>
   - **Expected invariant or safe-failure rule:** <one sentence>
   - **Hard invariants:**
     - <invariant>
     - <invariant>
   - **Soft invariants:**
     - <invariant>
     - <invariant>
   - **Allowed drift budget:**
     - <rule>
     - <rule>
   - **Transformed input package:** <execution-ready input>
   - **Notes for runner / judge:** <short notes>
3. **Optional variant record 3**
   - **Variant ID:** <id>
   - **Variant type:** <metamorphic | adversarial>
   - **Family:** <M1-M5 | A1-A6>
   - **Purpose:** <one sentence>
   - **Main transformation or stressor:** <one sentence>
   - **Route expectation:** <same as base | alternate accepted | intentionally stressed>
   - **Expected invariant or safe-failure rule:** <one sentence>
   - **Hard invariants:**
     - <invariant>
     - <invariant>
   - **Soft invariants:**
     - <invariant>
     - <invariant>
   - **Allowed drift budget:**
     - <rule>
     - <rule>
   - **Transformed input package:** <execution-ready input>
   - **Notes for runner / judge:** <short notes>
```
