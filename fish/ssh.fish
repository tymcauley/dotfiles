#
# Persistent SSH_AUTH_SOCK
#

# Point SSH_AUTH_SOCK to a global sym-link. When we create a zellij session, a particular
# SSH_AUTH_SOCK is captured. But if we lose connection to the server and then reconnect to the
# zellij SSH_AUTH_SOCK variable is always pointing to a global sym-link, and that the sym-link
# points to the "real" SSH_AUTH_SOCK socket.

# Only run this within an interactive ssh session.
if begin status is-interactive; and set -q SSH_TTY; end
    set -f run_dir /run/user/(id -u)

    # # Attempt to make the global sym-link specific to this SSH session.
    # if set -q SSH_TTY
    #     set -f ssh_tty_num "."(string split / $SSH_TTY)[-1]
    # else
    #     set -f ssh_tty_num ""
    # end
    # set -f global_ssh_auth_sock $run_dir/ssh_auth.sock$ssh_tty_num

    # Use a single global sym-link for this machine. While this might trample on the socket being
    # used by another ssh session to the same machine, it will also ensure that SSH_AUTH_SOCK
    # doesn't go stale when we log in from another SSH_TTY.
    set -f global_ssh_auth_sock $run_dir/ssh_auth.sock

    # If we're not in zellij, and there's an SSH_AUTH_SOCK variable...
    if begin not set -q ZELLIJ; and set -q SSH_AUTH_SOCK; and test -S $SSH_AUTH_SOCK; end
        # Set up a sym-link to the SSH_AUTH_SOCK socket, and then we'll use that sym-link as our
        # SSH_AUTH_SOCK variable within zellij.
        if test -w $run_dir
            # Get rid of the sym-link if it already exists. This is from a previous ssh session,
            # and will point to a stale socket.
            rm -f $global_ssh_auth_sock
            ln -s $SSH_AUTH_SOCK $global_ssh_auth_sock
        end
    end

    # If the sym-link is available, use it as our SSH_AUTH_SOCK.
    if test -L $global_ssh_auth_sock
        set -gx SSH_AUTH_SOCK $global_ssh_auth_sock
    end
end
