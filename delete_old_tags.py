import os
import subprocess
import logging

# === CONFIGURATION ===
WORKING_DIR = os.getcwd()  # Directory with git repos and *_old_tags.txt files
TAG_SUFFIX = '_old_tags.txt'
LOG_FILE = 'delete_git_tags.log'

# === SETUP LOGGING ===
logging.basicConfig(
    filename=LOG_FILE,
    filemode='w',
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

def run_git_command(repo_path, args):
    try:
        result = subprocess.run(
            ['git'] + args,
            cwd=repo_path,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        logging.error(f"[{repo_path}] Error running git {' '.join(args)}:\n{e.stderr.strip()}")
        return None

def delete_tags_for_repo(repo_path, tag_file_path):
    repo_name = os.path.basename(repo_path)
    logging.info(f"Processing repo: {repo_name}")

    with open(tag_file_path, 'r') as f:
        tags = [line.strip() for line in f if line.strip()]
    
    for tag in tags:
        logging.info(f"[{repo_name}] Deleting tag: {tag}")
        
        # Delete local tag
        local_del = run_git_command(repo_path, ['tag', '-d', tag])
        if local_del is not None:
            logging.info(f"[{repo_name}] Local tag deleted: {tag}")
        
        # Delete remote tag
        remote_del = run_git_command(repo_path, ['push', 'origin', f':refs/tags/{tag}'])
        if remote_del is not None:
            logging.info(f"[{repo_name}] Remote tag deleted: {tag}")

def main():
    logging.info(f"Starting tag deletion in directory: {WORKING_DIR}")
    
    for entry in os.listdir(WORKING_DIR):
        entry_path = os.path.join(WORKING_DIR, entry)

        # Look for git directories only
        if os.path.isdir(entry_path) and os.path.isdir(os.path.join(entry_path, '.git')):
            tag_file = os.path.join(WORKING_DIR, f"{entry}{TAG_SUFFIX}")
            if os.path.exists(tag_file):
                delete_tags_for_repo(entry_path, tag_file)
            else:
                logging.warning(f"Tag file not found for repo: {entry}")

    logging.info("Completed tag deletion process.")

if __name__ == "__main__":
    main()
