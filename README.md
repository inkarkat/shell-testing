# Shell Testing

_Test hooks and utilities for shell scripts._

![Build Status](https://github.com/inkarkat/shell-testing/actions/workflows/build.yml/badge.svg)

### Dependencies

* Bash
* [inkarkat/shell-basics](https://github.com/inkarkat/shell-basics)
* automated testing is done with _Bats_ - [Bash Automated Testing System](https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.

### See Also

* [inkarkat/shell-debugging](https://github.com/inkarkat/shell-debugging) has debugging aids for shell scripts. Many of those commands (among them a `debugeval` variant closely related to `testeval`) are also embedded in shell scripts, but activated by the developer for debugging, not by automated tests.
