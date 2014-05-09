echo "Do you have any cheese at all?"

pip_bootstrap_runtime () {

    if [[ -n "${PYTHON_USER_BIN}" ]]; then
        # Already sourced.
        return 0;
    fi;

    export PYTHON_USER_BIN="$(python -m site --user-base)/bin";
    export PYTHON_USER_LIB="$(python -m site --user-site)";

    export PATH="${PYTHON_USER_BIN}:${PATH}";

    if [[ "$(uname)" == "Darwin" ]]; then
        export STANDARD_CACHE_DIR="${HOME}/Library/Caches/org.pip-installer.pip";
    else
        export STANDARD_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/pip";
    fi;

    export WHEELHOUSE="${STANDARD_CACHE_DIR}/Wheelhouse";

    # Configure pip to always do the thing it should do out of the box, and not
    # re-download packages every time I sneeze.
    export PIP_USE_WHEEL="yes";
    export PIP_DOWNLOAD_CACHE="${STANDARD_CACHE_DIR}/Downloads";
    export PIP_FIND_LINKS="file://${WHEELHOUSE}";
    export PIP_WHEEL_DIR="${WHEELHOUSE}";

    if [[ -e "${PYTHON_USER_BIN}/virtualenvwrapper.sh" ]]; then
        source "${PYTHON_USER_BIN}/virtualenvwrapper.sh";
    fi;

    function pip () {

        # When you run "pip install" in your regular shell outside a
        # virtualenv, it should just work, meaning, install stuff into your
        # home directory.  But, let’s not affect the operation of pip within
        # virtualenvs or as executed by any tools (such as tox or virtualenv
        # itself) which need to run it via automation and not via a shell.

        if [[ -z "${VIRTUAL_ENV:-}" ]]; then
            env PIP_USER=yes pip "$@";
        else
            command pip "$@";
        fi;
    }
}

pip_bootstrap_runtime;

echo "Yes sir"
echo "Now I'm going to ask you that question once more"
echo "  If you say no I'm going to shoot you through the head."
echo "  Now, do you have any cheese at all?"
echo "No."

echo "**BANG**"
echo "Python is all set"

