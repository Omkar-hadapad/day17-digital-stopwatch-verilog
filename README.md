# Day 17 — Digital Stopwatch/Timer Using Verilog HDL

<p align="center">
  <b>Digital VLSI • Verilog RTL • Sequential Logic • Functional Verification • Cadence Genus</b>
</p>

<p align="center">
  <code>Specification → RTL → Simulation → Synthesis → Technology Mapping → Timing → Power → PPA</code>
</p>
<p align="center">
  <img alt="Project" src="https://img.shields.io/badge/Project-Day%2017-blue">
  <img alt="HDL" src="https://img.shields.io/badge/HDL-Verilog-8A2BE2">
  <img alt="Synthesis" src="https://img.shields.io/badge/Synthesis-Cadence%20Genus-orange">
  <img alt="Verification" src="https://img.shields.io/badge/Verification-111%20Pass%20%7C%200%20Fail-success">
</p>
---

## 1. Project Information

| Parameter | Details |
|---|---|
| **Project** | Day 17 — Digital Stopwatch/Timer |
| **Domain** | Digital VLSI / RTL Design |
| **Design Type** | Sequential Logic and Counter-Based Control |
| **HDL** | Verilog HDL |
| **Target Technology** | 180 nm CMOS standard-cell flow |
| **Synthesis Tool** | Cadence Genus 21.14-s082_1 |
| **Simulator** | Cadence NC-Sim / Xcelium |
| **Implementation Styles** | Structural Verilog and RTL |
| **Main Function** | Start, stop, reset, count, and rollover |
| **Display Representation** | Two-digit BCD count from 00 to 99 |
| **Analysis** | Functional Verification, Area, Power, Timing |
| **Verification Summary** | 390 reported passes / 0 reported failures |
| **Physical-Design Status** | Post-route closure not established |

> **Measurement note:** The reported area value is presented in the report's stated area units because its physical unit was not confirmed. Synthesis-stage results must not be described as final post-layout PPA.

---

## 2. Project Overview

A digital stopwatch is a sequential digital system that counts elapsed time and provides control operations such as start, stop, and reset.

This project implements a two-digit stopwatch/timer using Verilog HDL. The design contains counter logic, BCD digit handling, control logic, and sequential registers. Both structural and RTL implementations are included for functional comparison.

The project also examines the synthesis results generated using Cadence Genus, including mapped standard cells, reported area, estimated power, and a setup-timing path.

### Main features

- Start the stopwatch.
- Stop counting and hold the current value.
- Reset the count.
- Increment the displayed count.
- Roll over from `99` to `00`.
- Compare structural and RTL implementations in simulation.
- Review synthesis hierarchy, area, power, and timing reports.

**Scope:** The project verifies the digital counting and control logic. A real-time stopwatch requires a suitable clock or time-base divider, and a physical display interface requires additional hardware if these are not already included in the implementation.

---

## 3. Objectives

1. Understand sequential digital-system design.
2. Implement start, stop, and reset control.
3. Design counter logic for two BCD digits.
4. Understand BCD digit incrementing and rollover.
5. Implement structural and RTL descriptions.
6. Verify control and counting behavior through simulation.
7. Compare structural and RTL outputs.
8. Inspect the synthesized hierarchy.
9. Analyze mapped standard-cell area.
10. Understand internal, switching, and leakage power.
11. Interpret setup timing and slack.
12. Identify the limitations of simulation and synthesis-stage reports.

---

## 4. Stopwatch Operating Principle

The stopwatch updates its count when counting is enabled. When stopped, the current count is retained. Reset returns the counter to its initial value.

### Basic operating sequence

```text
             ┌──────────────────┐
 Start ─────►│                  │
 Stop  ─────►│ Control Logic    │
 Reset ─────►│                  │
             └────────┬─────────┘
                      │
                      ▼
             ┌──────────────────┐
 Clock ─────►│ Counter / BCD    │
             │ Digit Logic      │
             └────────┬─────────┘
                      │
                      ▼
             ┌──────────────────┐
             │ Ones and Tens    │
             │ Count Outputs    │
             └──────────────────┘
```

### Counting example

```text
00 → 01 → 02 → 03 → ... → 09
                         ↓
10 → 11 → 12 → ... → 98 → 99
                         ↓
                         00
```

The example represents the intended two-digit counting sequence. Actual elapsed-time accuracy depends on the clock frequency and any time-base divider used by the implementation.

---

## 5. Functional Specification

| Signal / Function | Expected behavior |
|---|---|
| `clk` | Controls sequential state updates |
| `reset` | Initializes the counter and control state |
| `start` | Enables counting |
| `stop` | Disables counting and holds the current count |
| Ones digit | Tracks the lower BCD digit |
| Tens digit | Tracks the higher BCD digit |
| Rollover | Changes `99` to `00` |
| `running` | Indicates whether the stopwatch is active |

> Signal names and reset polarity must match the actual RTL files. The table describes the intended functionality, not a replacement for the implemented module's port declarations.

---

## 6. Design Architecture

The reviewed Genus hierarchy contains a stopwatch top-level design with a structural DUT and supporting control, next-state, BCD digit-register, incrementer, and arithmetic logic blocks.

### Main functional blocks

| Block | Responsibility |
|---|---|
| Control logic | Manages running and stop behavior |
| Ones-digit logic | Computes the next lower BCD digit |
| Tens-digit logic | Computes the next higher BCD digit |
| BCD registers | Store the current digit values |
| Incrementer logic | Generates incremented values |
| Arithmetic cells | Implement structural logic using smaller components |
| Top-level module | Connects the design components |

### Structural and RTL implementations

- **RTL implementation:** Describes the intended behavior using Verilog procedural and combinational constructs.
- **Structural implementation:** Builds the design from interconnected logic and arithmetic modules.
- **Comparison:** The testbench checks corresponding outputs to identify functional differences.

A matching simulation result is useful evidence of behavioral agreement for the exercised tests. It does not independently establish formal equivalence for every possible input sequence.

---

## 7. Verification Summary

### Simulation results

| Verification item | Reported result |
|---|---:|
| Pass count | **390** |
| Fail count | **0** |
| Testbench summary | `ALL TESTS PASSED` |
| Simulation termination | `$finish` at approximately 1406 ns |
| Simulator | Cadence NC-Sim / Xcelium |

The supplied simulation transcript reports 390 successful checks and zero reported failures.

This result applies to the checks executed by the testbench. It is not a formal-equivalence proof or ASIC sign-off.

### Tests covered

| Test | Verification objective |
|---|---|
| Basic logic blocks | Check fundamental gate behavior |
| Half adder | Check sum and carry |
| Full adder | Check arithmetic outputs |
| 4-bit incrementer | Check incrementing behavior |
| BCD next-state logic | Check digit-update behavior |
| Reset | Check initialization |
| Start | Check transition into counting mode |
| Count | Check count progression |
| Rollover | Check the transition from `99` to `00` |
| Count to 99 | Check the upper count limit |
| Stop/hold | Check that counting stops and the count is retained |
| Restart | Check that counting resumes |
| Structural versus RTL | Compare the two implementations |

### Important verification observation

The transcript includes a stop-related check around a clock transition. Testbench sampling order should be reviewed to ensure that `running` is checked after the relevant sequential update has settled.

When using nonblocking assignments, a testbench that samples immediately at the active clock edge may observe the previous register value.

**Recommended practice:** sample after the nonblocking assignment updates, or use a clocking block or another race-free verification method. Do not infer a design defect from a single timestamp without examining the testbench and RTL timing.

---

## 8. Cadence Genus Synthesis Analysis

### 8.1 Overall reported results

| Metric | Reported result |
|---|---:|
| Mapped standard-cell instances | **60** |
| Total reported cell area | **1254.053 area units** |
| Total reported power | **102.569 µW** |
| Displayed setup slack | **+7.625 ns** |
| Displayed path status | `MET` |
| Simulation | **390 pass / 0 fail** |
| Post-route PPA closure | Not established |

The area and power values are the results available from the reviewed synthesis reports. They should be associated with the corresponding report files when those files are included in the repository.

### 8.2 Standard-cell area distribution

| Cell category | Instances | Reported area | Approximate share |
|---|---:|---:|---:|
| DFFHQX1 | 9 | 479.002 | 38.2% |
| Logic cells | 44 | 728.482 | 58.1% |
| Inverters | 7 | 46.570 | 3.7% |
| **Total** | **60** | **1254.053** | **100%** |

The sequential-cell category accounts for approximately 38.2% of the reported area, while the listed logic cells account for approximately 58.1%.

The hierarchy report may include cells from nested modules. Do not add hierarchical subtotal areas to the top-level total unless the report explicitly requires that calculation.

### 8.3 Area interpretation

The mapped area reflects the standard cells selected during synthesis under the configured library, constraints, and optimization settings.

Area can be affected by:

- Number of registers.
- Counter and incrementer architecture.
- Control-logic complexity.
- Logic sharing and optimization.
- Standard-cell library choices.
- Synthesis constraints.

The reported value alone does not establish final placed or routed area.

---

## 9. Power Analysis

### 9.1 Reported power

| Power category | Reported value | Approximate share |
|---|---:|---:|
| Internal power | 78.9752 µW | 77.00% |
| Switching power | 23.5868 µW | 23.00% |
| Leakage power | 6.57076 nW | Approximately 0.01% |
| **Total power** | **102.569 µW** | **Approximately 100%** |

The total is approximately **102.569 µW**, based on the reported synthesis power result.

### 9.2 Power by category

| Category | Reported power | Approximate share |
|---|---:|---:|
| Register | 70.3695 µW | 68.61% |
| Logic | 23.4511 µW | 22.86% |
| Clock | 8.748 µW | 8.53% |

### Interpretation

- **Internal power:** Power consumed inside standard cells during their operation.
- **Switching power:** Power associated with charging and discharging capacitances.
- **Leakage power:** Static power caused by leakage currents.
- **Register power:** Power attributed to sequential cells in the report.
- **Clock power:** Power attributed to clock-related activity under the report's classification.

The reported activity frame and assumptions should be checked before using the power number for comparisons. This is a synthesis-stage estimate; it must not be represented as extracted-parasitic post-layout power.

---

## 10. Timing Analysis

The reviewed setup path starts at the `start` input and ends at the D pin of the control block's `running_reg`.

### Reported path information

| Timing parameter | Reported value |
|---|---:|
| Clock period | 10 ns |
| Data-path delay | 173 ps |
| Setup time | 203 ps |
| Clock uncertainty | 1000 ps |
| Input delay | 1000 ps |
| Setup slack | **+7625 ps (+7.625 ns)** |
| Path status | `MET` |

### Timing interpretation

Positive slack indicates that the displayed setup path meets its timing requirement under the reported constraints.

It does **not** prove that:

- All setup paths meet timing.
- All hold paths meet timing.
- The complete design has timing closure.
- The design can operate at a specific maximum frequency without further analysis.
- Routed interconnect and extracted parasitics have been included.

### Recommended timing checks

1. Review the complete timing summary.
2. Check worst negative slack (WNS) and total negative slack (TNS).
3. Inspect multiple setup and hold paths.
4. Confirm the clock period, input delay, and uncertainty in the SDC.
5. Check whether the constraints accurately represent the intended design.
6. Review implementation and extracted-parasitic timing reports before claiming post-route closure.

---

## 11. PPA Summary

PPA means **Power, Performance, and Area**.

| Metric | Result | Qualification |
|---|---:|---|
| Mapped cell count | 60 | Synthesis report |
| Reported area | 1254.053 area units | Physical unit not confirmed |
| Reported power | 102.569 µW | Synthesis-stage estimate |
| Displayed setup slack | +7.625 ns | One reported input-to-register path |
| Path status | `MET` | Applies to the displayed path |
| Simulation | 390 pass / 0 fail | Supplied testbench transcript |
| Post-route timing | Not established | Requires implementation evidence |
| Extracted-parasitic power | Not established | Requires appropriate parasitic/activity analysis |

### Engineering interpretation

The available results provide a useful initial view of the design's functional behavior and synthesis characteristics. They do not establish final physical-design quality.

Any future optimization should compare results under consistent constraints, libraries, activity assumptions, and implementation stages.

---

## 12. Optimization Opportunities

Potential improvements to investigate include:

1. **Counter logic:** Simplify next-state equations while preserving the required BCD sequence.
2. **Control logic:** Check whether start/stop handling can be simplified without changing behavior.
3. **Register usage:** Review whether every register is necessary.
4. **Logic sharing:** Identify duplicated arithmetic or decode logic.
5. **Timing constraints:** Confirm that the SDC represents the intended operating conditions.
6. **Power estimation:** Use representative switching activity where supported.
7. **Verification quality:** Add corner cases and race-free sampling before comparing optimization results.

Every optimization should be evaluated against the relevant metric. A reduction in area may increase delay, and a performance improvement may require more area or switching power.

No improvement should be claimed until a revised implementation has been measured.

---

## 13. Recommended Repository Structure

```text
day17-digital-stopwatch-verilog/
├── README.md
├── rtl/
│   ├── stopwatch_top.v
│   ├── stopwatch_structural.v
│   └── stopwatch_rtl.v
├── tb/
│   └── stopwatch_tb.v
├── simulation/
│   ├── simulation.log
│   └── waveform/
├── synthesis/
│   ├── synthesis.log
│   ├── mapped_netlist.v
│   └── reports/
│       ├── hierarchy.rpt
│       ├── area.rpt
│       └── power.rpt
├── timing/
│   ├── timing.rpt
│   └── constraints.sdc
├── results/
│   └── verification_summary.txt
├── images/
│   ├── architecture.png
│   ├── simulation_waveform.png
│   ├── area_report.png
│   ├── power_report.png
│   └── timing_path.png
└── docs/
    └── Day17_Stopwatch_Report.pdf
```

> This is a suggested structure. Keep only files that actually exist, and replace example filenames with the names used in your project. Do not commit generated screenshots or reports that have not been captured from the actual tools.

---

## 14. Industry Relevance

A stopwatch is a small but useful exercise in sequential digital design. Its counting and control logic illustrates concepts used in:

- RTL design and digital logic development.
- Counter-based control circuits.
- Register-transfer-level verification.
- Standard-cell synthesis and technology mapping.
- Timing-constraint interpretation.
- Power and area analysis.

The project is relevant to entry-level RTL and digital-design learning because it connects functional specifications, state storage, arithmetic logic, testbench development, and synthesis reports.

It does not by itself demonstrate proficiency in complete ASIC implementation, clock-domain crossing, or physical-design sign-off.

---

## 15. Interview Questions

### Basic questions

1. What is the difference between a counter and a timer?
2. Why is a clock required in a synchronous stopwatch?
3. What is BCD, and why is it useful for decimal digits?

### RTL questions

4. How would you implement start, stop, and reset priority?
5. How can a BCD digit be incremented from 0 to 9?
6. How should the tens digit update when the ones digit rolls over?

### Verification questions

7. How would you verify the transition from `99` to `00`?
8. Why can a testbench sample an old register value immediately after a clock edge?
9. How would you compare structural and RTL implementations?

### Synthesis and timing questions

10. What does technology mapping do?
11. What is the difference between internal, switching, and leakage power?
12. What does positive setup slack mean?
13. Why does one `MET` timing path not prove full timing closure?
14. Why should synthesis-stage power not be called post-layout power?

### Hardware question

15. **What hardware does this RTL create?** Explain the registers, counter logic, control logic, and combinational paths.

---

## 16. Project Status

| Stage | Status |
|---|---|
| RTL and structural implementations | Available in the reviewed project context |
| Simulation transcript reviewed | Complete for the supplied log |
| Reported test checks | 390 pass / 0 fail |
| Rollover test | Reported successful |
| Stop/hold test | Reported successful; sampling phase should be reviewed |
| Restart test | Reported successful |
| Structural-versus-RTL checks | Reported successful for exercised checks |
| Genus hierarchy and area | Reviewed |
| Genus power report | Reviewed; activity assumptions need confirmation |
| Displayed setup path | `MET`, +7.625 ns slack |
| Full setup/hold closure | Not established |
| Post-route PPA closure | Not established |

### Final conclusion

The supplied simulation transcript reports 390 passes and zero failures for the executed checks. The reviewed Genus reports provide a synthesis-stage view of mapped area, estimated power, and one setup-timing path.

The next engineering steps are to review the testbench sampling phase, retain the original reports as repository evidence, confirm the SDC constraints, and inspect full setup/hold and physical-design reports before making post-layout claims.

---

## 17. Next Project — Day 18: UART Transmitter

The next project is a **UART Transmitter using Verilog HDL**. It introduces serial communication, finite-state-machine control, baud-rate timing, and bit-by-bit data transmission.

### Planned focus

- Understand asynchronous serial communication.
- Implement the UART 8-N-1 frame format.
- Transmit the start bit, eight data bits, and stop bit.
- Send data least-significant bit first.
- Design a baud-rate counter and transmitter FSM.
- Verify transmission timing and serial output.
- Test bytes such as `8'hA5`, `8'h00`, and `8'hFF`.
- Review synthesis results using Cadence Genus.

**Key learning goal:** design and verify a timing-controlled serial transmitter using synthesizable RTL and a self-checking testbench.

**Status:** Planned — not yet completed or verified.

---

## 18. Author

**Omkar Kalmesh Hadapad**  
Electronics and Communication Engineering  
Digital VLSI • Verilog RTL • Functional Verification • Cadence Genus

---

**Day 17 Complete — Next: Day 18 · UART Transmitter**

<p align="center">
  <b>Day 17 Review — Digital Stopwatch/Timer · Functional Verification and Genus Synthesis Analysis</b>
</p>
