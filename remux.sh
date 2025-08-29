#!/bin/bash

# Set the name of the subtitle directory
SUB_DIR="Subs"

# Check if the subtitle directory exists
if [ ! -d "$SUB_DIR" ]; then
  echo "Error: Subtitle directory '$SUB_DIR' not found."
  echo "Please run this script from your main movie directory."
  exit 1
fi

# Loop through all .mp4 files in the current directory
for video_file in *.mp4; do
  # Get the filename without the .mp4 extension
  basename=$(basename "$video_file" .mp4)

  # Define the output MKV filename
  output_file="${basename}.mkv"

  # Define the corresponding subtitle directory for this movie
  subtitle_path="$SUB_DIR/$basename"

  # Check if the specific subtitle directory exists
  if [ -d "$subtitle_path" ]; then
    echo "Processing '$video_file'..."

    # Find all .srt files in the subtitle directory and store them in an array
    mapfile -t srt_files < <(find "$subtitle_path" -type f -name "*.srt" | sort)

    # Check if any subtitle files were actually found
    if [ ${#srt_files[@]} -gt 0 ]; then
      # Run the mkvmerge command
      mkvmerge \
        -o "$output_file" \
        --engage no_cue_duration \
        --engage no_cue_relative_position \
        "$video_file" \
        "${srt_files[@]}"

      echo "Successfully created '$output_file'"
    else
      echo "Warning: No .srt files found in '$subtitle_path' for '$video_file'."
    fi
  else
    echo "Warning: No subtitle directory found at '$subtitle_path' for '$video_file'."
  fi
  echo "----------------------------------------"
done

echo "All movies processed."
