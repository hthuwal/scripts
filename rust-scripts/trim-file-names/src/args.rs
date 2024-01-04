use std::path::PathBuf;

use clap::Parser;

fn path_exists(path: &str) -> Result<PathBuf, String> {
    let path: PathBuf = path
        .parse()
        .map_err(|_| format!("`{path}` isn't a valid path"))?;

    if path.is_dir() {
        Ok(path)
    } else {
        Err(format!(
            "Path `{}` is not a valid directory",
            path.display()
        ))
    }
}

/// Simple program to greet a person
#[derive(Parser, Debug)]
pub struct CleanupArgs {
    /// path to directory containing files whose names need trimming
    #[arg(value_parser = path_exists)]
    directory: PathBuf,

    // Append the substrings to be removed to the default list.
    #[arg(short)]
    append: bool,

    /// Delimiter used to replace all '.'. Default is space.
    #[arg(short)]
    delimiter: String,

    /// Substrings to be removed
    #[arg(short, num_args = 1..)]
    substrings: Vec<String>,
}

impl CleanupArgs {
    pub fn directory(&self) -> &PathBuf {
        &self.directory
    }

    pub fn append(&self) -> bool {
        self.append
    }

    pub fn delimiter(&self) -> &String {
        &self.delimiter
    }

    pub fn substrings(&self) -> &Vec<String> {
        &self.substrings
    }
}
