#!/usr/bin/env python
import sys

def eprint(*args, **kwargs):
    # uncomment to enable debug...
    print(*args, file=sys.stderr, **kwargs)
    pass

def bash_it(cmd):
    eprint("bash_it", cmd)
    result = subprocess.run(["bash", "-c", cmd], capture_output=True)
    result = result.stdout.decode("utf-8")
    return result

def read_clipboard():
    # Read the clipboard on linux
    return subprocess.check_output(["xclip", "-o", "-sel", "clipboard"], universal_newlines=True)
    # Read the clipboard on macOS
    # return subprocess.check_output(["pbpaste"], universal_newlines=True)

    # Read the clipboard on Windows
    # return subprocess.check_output(["powershell", "-command", "Get-Clipboard"], universal_newlines=True)


def write_to_clipboard(text):
    # Write the text to the clipboard on Linux
    subprocess.run(["xclip", "-selection", "clipboard"], input = text.strip().encode('utf-8'), check=True)
    # bash_it("echo " + text +  "|" + "xclip -sel c")

    # Write the text to the clipboard on macOS
    # subprocess.run(["echo", "-n", text, "|", "pbcopy"], shell=True)

    # Write the text to the clipboard on Windows
    # subprocess.run(["powershell", "-command", "Set-Clipboard", text], shell=True)



def send_notif(title, message):
    eprint(title, message)
    subprocess.Popen(['notify-send', title, message])


import subprocess

commands = ['isbn to bibtex',
     'b',
     'c']


rofi_process = subprocess.Popen(['rofi', '-dmenu'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
selected_command, _ = rofi_process.communicate('\n'.join(commands))
selected_command = selected_command.strip()

if selected_command:
    send_notif("Command Execution", f'Executing command: {selected_command}')

    if selected_command == 'isbn to bibtex':
        clipboard = read_clipboard()
        isbn = bash_it(f"echo \"{clipboard}\n'Esc to Cancel'\" | rofi -dmenu")
        exit(0) if not isbn else False
        isbn = isbn.replace("\n", ",")
        res  = bash_it('echo ' + isbn + '| isbn_to_bibtex.py')
        write_to_clipboard(res)
        send_notif("status", "done!: "+ res)
    else:
        send_notif("Failure", "Unkown Command")
        exit(1)
else:
    print('No command selected')


exit(0)



