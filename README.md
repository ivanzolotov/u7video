# u7video

`u7video` is a Bash script for compressing video files and uploading them to a server.

## Version
Current version: **2.1**

## Author
This script was created by Ivan Zolotov with contributions from ChatGPT.

## Dependencies
- `ffmpeg` (for video file processing)
- `scp` (for file uploads to the server)

## Installation

### Steps for installation on macOS:
1. Create the `~/bin` directory if it doesn’t exist:
   ```bash
   mkdir -p ~/bin
   ```

2. Create a symbolic link:
   ```bash
   ln -s /path/to/u7video.sh ~/bin/u7video
   ```

3. Ensure the `~/bin` directory is added to the `PATH` variable in `~/.zshrc`:
   ```bash
   export PATH="$HOME/bin:$PATH"
   ```

4. Apply the changes:
   ```bash
   source ~/.zshrc
   ```

5. Verify that the script is executable from any directory:
   ```bash
   u7video help
   ```

The script is now installed and ready to use.

## Configuration

1. **Configure SSH:**
   Add an entry for your server in the `~/.ssh/config` file, for example:
   ```ssh
   Host myserver
       HostName XXX.XXX.XXX.XXX
       User web
       IdentityFile ~/keys/key
   ```

   Ensure the `Host` nickname (`myserver`) matches the value of the `SERVER_NICKNAME` variable in the script.

2. **Set the server file path:**
   Modify the `SERVER_PATH` variable in the script to specify the directory where processed files will be uploaded.

## Usage

The script supports the following options:

### Main commands:
- `mp4` — Create a compressed MP4 version of the video.
- `webm` — Create a compressed WebM version of the video.
- `both` — Create both versions.
- `upload` — Upload the compressed video versions to the server.
- `help` — Show usage instructions.
- `version` — Show the current version of the script.

### Default behavior
If no parameters are provided, the script runs as if the `both` and `upload` options were specified. It will:
1. Compress the video into both MP4 and WebM formats.
2. Upload the compressed files to the server.

### Usage examples:

1. Create an MP4 version:
   ```bash
   ./u7video mp4 0001.mp4
   ```

2. Create a WebM version:
   ```bash
   ./u7video webm 0001.mp4
   ```

3. Process and upload:
   ```bash
   ./u7video 0001.mp4
   ```

4. Upload already processed files:
   ```bash
   ./u7video upload 0001.mp4
   ```

## File requirements
The source file name must follow the format `0000.mp4`, where `0000` is a four-digit number. If the file name does not match this format, the script will terminate with an error.

## License
This script is provided "as is". Use at your own risk.
