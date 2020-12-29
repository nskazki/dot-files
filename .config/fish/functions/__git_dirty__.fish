function __git_dirty__
  __git_has_staged__ || __git_has_modified__ || __git_has_untracked__
end
