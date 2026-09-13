## 3.0.2

* chore: removed the unused `async` dependency
* chore: added a version constraint to the `lint` dev dependency
* chore: resolved all analyzer lints (`unnecessary_library_name`,
  `simplify_variable_pattern`, `async_return_with_no_await`, `unnecessary_async`)
* ci: updated the GitHub actions to their latest major versions and replaced the
  flutter setup in the test job with the dart setup
* ci: fixed the unquoted variable expansions in `bin/ensure_pana_score.sh`
* doc: fixed the outdated/broken references in the readme and the dartdoc
  comments (the return type is a `FutureOr`, `Failed` exposes `reason`)
* chore: aligned `.editorconfig` with what `dart format` produces and added
  a `.gitattributes` to normalise the line endings

## 3.0.1

* fix:  track was not ended when behaviour resulted in a future

## 3.0.0

* feat!: upgraded to dart v3
  - removed `whenSuccess` and `whenFailed` methods + variants from `ExceptionOr`
* feat: better usage of `FutureOr` functionality

## 2.1.1

* ci stuff

## 2.1.0

* ci: pipelines
* doc: updated readme
* feat: added more extensions for `ExceptionOr`

## 2.0.0

* feat: added helper methods for ExceptionOr
* feat: auto implemented description
* fix: fir call onCatch, then stop with error

## 1.0.0

* feat! added value to `ExceptionOrSuccess.thenStartNextWhenSuccess`

## 0.1.0

* feat: added default implementation for `onCatch`

## 0.0.3

* Downgrade `async` package dependency to be compatible with flutter

## 0.0.2

* Added the `BehaviourInterface` and `BehaviourInterface`
* Upgraded dependencies

## 0.0.1

* Initial version.
