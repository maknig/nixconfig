{ pkgs, ... }:

let

in
{


  programs.git = {
    enable = true;
    userName = "Matthias Koenig";
    userEmail = "matthias.koenig@gmail.com";
    #signing.key = "165AEDEB";

    extraConfig = {
      core = {
        pager = "less -FRSX";
        editor = "nvim";
      };
      color = {
        ui = "true";
        diff = "auto";
      };
      rerere = {
        enabled = 1;
      };

      merge = {
        tool = "nvim";
      };
      lfs.enable = true;
    };

    aliases = {
      s = "status";
      b = "branch";
      ba = "branch -a -v -v";
      bs = "!git-branch-status";
      bsi = "!git-branch-status -i";

      sw = "!git checkout $(git branch -a --format '%(refname:short)' | sed 's~origin/~~' | sort | uniq | fzf)";

      ci = "commit";
      co = "checkout";

      d = "diff -C";
      ds = "diff -C --stat";
      dsp = "diff -C --stat -p";
      dw = "diff -C --color-words";

      l = "log -C --decorate";
      ls = "log -C --stat --decorate";
      lsp = "log -C --stat -p --decorate";

      lc = "log ORIG_HEAD.. --stat --no-merges";

      lg = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s'";
      lga = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --all";
      l19 = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --all -19";
      lsd = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --all --simplify-by-decoration";
      lgr = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --first-parent";

      ru = "remote update";

      # "show-branch -g=N" can't be aliased for N easily, so we stop here:
      sb = "show-branch --sha1-name";

      ls-del = "ls-files -d";
      ls-mod = "ls-files -m";
      ls-new = "ls-files --exclude-standard -o ";
      ls-ign = "ls-files --exclude-standard -o -i";

      whois = "!sh -c 'git log -i -1 --pretty=\"format:%an <%ae>\n\" --author=\"$1\"' -";
      whatis = "show -s --pretty='tformat:%h (%s, %ad)' --date=short";

      # locate = "!sh -c 'git ls-files "\\ * $1 "' -";

      # edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
      # add-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";

      edit-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; v `f`";
      add-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; git add `f`";

      # fixup
      fu = "commit --amend --reset-author -C HEAD";
      fuu = "!git add -u && git fu";
    };
  };
}
