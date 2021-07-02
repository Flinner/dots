# get weather, example: weather New York
weather () { curl wttr.in/"$*"; }

# get public ip address
ip.me () { curl eth0.me ; curl ipv6.icanhazip.com } # or ip.me

# 0x0, upload files and use as pastebin example: 0x0 file.sh
0x0 () {
  [ ! -z "$1" ] && file=$1 || file=$(find . -maxdepth 2 -type f | fzf)
  [ -z "$file" ] && return
  echo "file=@$file"
  curl -F "file=@$file" 0x0.st | xclip -sel clip
}

# get QR code, helpful for sharing links
qrcode () { curl "qrenco.de/$*" ; }

# open file with fzf
fv () { $EDITOR "$( fd --follow --hidden "$@" | fzf --preview="bat --color=always {} || cat {} || ls {}")"  ; }

# takes one arg
get-video-length () { exiftool -ext mp4 -ext mkv -r -n -q -p '${Duration;$_ = ConvertDuration(our $total += $_)}' "$1" | tail -n 1  ; }

chmodx-last () { chmod +x "$_"  ; }


# keep running , screw systemd
keep () { systemd-run --scope --user "$*"  ; }

# file manager
xplr () {
  while true
  do
    dirs="$(fd | grep -v \~)"
    sel=$(echo -e $dirs\\n.. | sk --tiebreak=length,score,index -c "echo -e 'delete\nmove\n' | grep '{}'" \
      -p "xplr: " --cmd-prompt="action: ")
          [[ -d $sel ]] && cd $sel && continue
          [[ -e $sel ]] && xdg-open $sel 2> /dev/null

          [[ $sel == "" ]] && return
          [[ $sel == "delete" ]] && rm -rf $(fd | grep -v \~ | sk --tiebreak=length,score,index -m -p "delete: ")

          [[ $sel == "move" ]] && mv $(fd | grep -v \~ | sk --tiebreak=length,score,index -m -p "select file: ") \
            $(fd | grep -v \~ | sk --tiebreak=length,score,index -c "fd | grep -v \~ | grep '{}' || echo {}" -i --cmd-prompt="select destination: ")
          done
        }


