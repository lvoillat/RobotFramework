import sys
import re
import os

def clean_timestamps(input_file, output_file):
    """
    Reads an XML file, removes microseconds from timestamps, and writes to a new file.
    Example: 2026-03-24T13:39:03.327914+0000 -> 2026-03-24T13:39:03+0000
    """
    print(f"Cleaning timestamps in '{input_file}' and saving to '{output_file}'...")
    try:
        with open(input_file, 'r', encoding='utf-8') as infile:
            content = infile.read()

        # Regex to find ISO 8601 timestamps with fractional seconds and timezone offset
        # It captures the date, time (up to seconds), and timezone offset.
        # It then reconstructs the string without the fractional seconds.
        cleaned_content = re.sub(r'(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})\.\d{6}([+-]\d{4})', r'\1\2', content)

        with open(output_file, 'w', encoding='utf-8') as outfile:
            outfile.write(cleaned_content)
        print("Timestamps cleaned successfully.")
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred during cleaning: {e}")
        sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python clean_output_xml.py <input_output_xml_path> <cleaned_output_xml_path>")
        sys.exit(1)

    input_xml_path = sys.argv[1]
    output_xml_path = sys.argv[2]
    clean_timestamps(input_xml_path, output_xml_path)
