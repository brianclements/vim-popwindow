# Roadmap

## Unscheduled
* Add configuration settings for:
  * some of the aggressiveness options listed above when closing windows.
  * Whether to start closing normal buffers or not when special buffers are all
    closed.

* Add functionality to detect if current buffer is open in another window in any
  tab. If not, do `bdelete` on buffer when popping normal buffer windows. If
  buffer is open elsewhere, just do a close window.
