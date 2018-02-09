# Ansible role 'zsh'

An Ansible role for setting up zsh and oh-my-zsh. It is primarly intended for use with powerline (see my separate repo).

## Requirements
Since the revamp, only Fedora is currently supported and tested.
Should work with any distro for which the `package` module
works and the package names for git/zsh are `git` and `zsh`. Feel free to hollar
if you run into exceptions here.

## Role Variables
| Variable                       | Default                          | Comments (type)  |
| :---                           | :---                             | :---             |
| `userlist` | | list of users and their homedir root, **this is required to set in host/group vars or playbook (God forbid)** |
| `ls` | ls (exa for debian and arch) | the command ls should execute |
| roficolor | CC6666 | hexadecimal value for rofi main color

## Dependencies
No role dependencies. 

## Example Playbook
```Yaml
- hosts: foo
  roles:
    - role: zsh
```

## Testing

## License

BSD

## Contributors

Issues, feature requests, ideas, suggestions, etc. are appreciated and can be posted in the Issues section. Pull requests are also very welcome. Please create a topic branch for your proposed changes, it's the easiest way to merge back into the project.

- [Oscar Petersson](https://github.com/oscpe262/) (Maintainer)
