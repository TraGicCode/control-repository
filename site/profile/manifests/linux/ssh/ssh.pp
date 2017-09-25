class profile::linux::ssh::ssh(

) {
    # Prevent hacker from brute forcing accounts password
    # Find sshd_config
    # Set PasswordAUthentication to the following line
    # PasswordAuthentication no
    # Restart ssh service afterward to pick up new change
}