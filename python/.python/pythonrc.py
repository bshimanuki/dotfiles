try:
    import atexit
    import os
    import readline
    import rlcompleter

    historyPath = os.path.expanduser("~/.python/.pyhistory")

    def save_history(historyPath=historyPath):
        import readline
        readline.write_history_file(historyPath)

    if os.path.exists(historyPath):
        readline.read_history_file(historyPath)

    atexit.register(save_history)
    del os, atexit, readline, rlcompleter, save_history, historyPath

except ImportError:
    print("Module readline not available.")

