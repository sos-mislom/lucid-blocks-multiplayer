# Decomposition Notes

Working notes for splitting `coop_manager.gd` into stateful runtime managers.
This file records intermediate decisions so the refactor can move in small,
testable blocks.

## 2026-05-26 - Stateful Runtime Pass

### Current map

`coop_manager.gd` already delegates many pure decisions to helper modules such as
`CoopReconnect`, `CoopPlayerSync`, `CoopEntitySync`, `CoopDropSync`,
`CoopWorldJournal`, `CoopStatus`, `CoopAdmin`, and `CoopBuilder`.

The remaining problem is that the live mutable runtime state still sits in the
manager as many top-level variables. The biggest clusters are:

- client session/leave/reconnect/restore flags;
- incoming host world snapshot buffers;
- server dirty chunk and chunk-ticket state;
- client/server block and item action caches;
- entity/drop interest and interpolation caches;
- UI node references.

### Boundary chosen for block 1

Start with `CoopClientSessionRuntime`.

Scope:

- `local_quit_in_progress`;
- `client_restore_in_progress`;
- `client_menu_kick_pending`;
- `client_menu_kick_sequence`;
- `reconnect_pending`;
- `reconnect_attempt_count`;
- `reconnect_retry_timer`;
- `reconnect_reason`;
- `reconnect_steam_lobby_id`;
- `reconnect_steam_host_id`;
- `host_rehost_pending`;
- `host_rehost_port`;
- `receiving_host_world`.

Reason:

- this state caused recent leave/reconnect regressions;
- it is narrow enough to move without touching block/entity/drop authority;
- the network RPC entry points can stay on `coop_manager.gd`.

Non-goals for this block:

- do not move `@rpc` functions;
- do not change wire protocol;
- do not change save, block, item, entity or chunk behavior.

### Block 1 result

Added `mod/overrides/coop_mod/coop_client_session_runtime.gd`.

`coop_manager.gd` now owns one `client_session_runtime` object instead of
top-level fields for the client leave/reconnect/restore state listed above.
The manager still performs engine operations such as UI overlays, `Ref.main`
calls, `multiplayer` peer changes and RPC dispatch.

Added focused tests in
`mod/overrides/tests/coop_client_session_runtime/test_session_runtime_lifecycle.gd`.

Validation:

- focused runtime test: 1 file, 31 asserts;
- full release hygiene should be run after each subsequent block.

### Next candidate blocks

1. `CoopWorldMutationRuntime`: dirty chunk keys, chunk tickets, action result caches.
2. `CoopInterestRuntime`: entity/drop interest caches and counters.
3. `CoopMenuRuntime`: UI node references and browser page state.

## 2026-05-26 - Snapshot Receive Runtime

### Boundary chosen for block 2

Move the host-world snapshot receive buffer into `CoopSnapshotReceiveRuntime`.

Scope:

- incoming snapshot register JSON;
- expected snapshot chunk count;
- received compressed chunk map;
- host position used after load;
- follow-host-position flag.

Reason:

- this is a pure mutable receive buffer with a clear lifecycle:
  begin -> receive chunks -> finish/apply -> clear;
- RPC handlers and world loading can stay on `coop_manager.gd`;
- it reduces another top-level state cluster without touching gameplay
  authority.

Non-goals:

- do not move snapshot RPC entry points;
- do not change snapshot wire format;
- do not change save sanitization or world loading.
