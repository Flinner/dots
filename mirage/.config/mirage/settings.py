self.include_builtin("config/settings.py")

class General:
    zoom: float = 1.0
    compact: bool = False
    # tooltips_delay: float = 5000
    theme: str = "myGlass.qpl"
    wrap_history: bool = False

class Notifications:
    use_html: bool = False

class Scrolling:
    kinetic: bool = False

class Chat:
    max_messages_line_length: int = 130

class Keys:

    earlier_page = ["Ctrl+H"]
    later_page = ["Ctrl+Y"]

    quit = ["Ctrl+Q"]

    class Rooms:
        focus_filter = ["Ctrl+K"]

        # Switch to the room with the oldest/latest unread message.
        latest_unread = ["Ctrl+L"]

    class Messages:
        reply = ["Ctrl+R"]
        remove = ["Ctrl+Shift+R"]
        previous = ["Ctrl+Up", "Ctrl+I"]
        next = ["Ctrl+Down", "Ctrl+U"]

