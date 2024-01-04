mod args;
mod path_cleaner;

use std::{
    fs::{self, DirEntry},
    path::Path,
};

use args::CleanupArgs;
use path_cleaner::PathCleaner;

use clap::Parser;

const USUAL_CRAP: &[&str] = &[
    "720p", "WEBRip", "2CH", "x265", "HEVC-PSA", "WEB-DL", "1080p", "10bit", "6CH", "BrRip",
];

fn get_list_of_files(path: &Path) -> Result<impl Iterator<Item = DirEntry>, String> {
    let files = fs::read_dir(path)
        .map_err(|e| format!("Error reading directory: {}", e))?
        .filter_map(|entry| entry.ok()) // filter out errors
        .filter(|entry| entry.path().is_file()) // filter out directories
        .filter(|entry| {
            // filter out hidden files
            if let Some(file_name) = entry.file_name().to_str() {
                return !file_name.starts_with(".");
            }
            return false;
        });

    Ok(files)
}

fn clean(args: &CleanupArgs) -> Result<(), String> {
    // Get List Of Files in the directory
    let files = get_list_of_files(args.directory().as_path());
    let files = match files {
        Ok(v) => v,
        Err(e) => return Err(e),
    };

    let mut crap = args.substrings().clone();
    if args.append() {
        for uc in USUAL_CRAP {
            crap.push(uc.to_string())
        }
    }

    let path_clenaer: PathCleaner<'_> = PathCleaner::new(crap.as_slice(), &args.delimiter());

    for file in files {
        let file_path = file.path();

        let new_path = match path_clenaer.clean(file_path.as_path()) {
            Ok(v) => v,
            Err(e) => {
                println!("Error cleaning file path: {}", e);
                continue;
            }
        };

        if file_path == new_path {
            println!("Skipping {:?} => {:?}", file_path, new_path);
            continue;
        }

        println!("Renaming {:?} => {:?}", file_path, new_path);
        fs::rename(file_path, new_path).map_err(|e| format!("Error renaming file: {}", e))?;
    }
    Ok(())
}

fn main() {
    let args = CleanupArgs::parse();
    if let Err(e) = clean(&args) {
        println!("{}", e);
    }
}
