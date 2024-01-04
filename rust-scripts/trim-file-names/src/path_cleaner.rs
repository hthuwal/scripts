use std::path::{Path, PathBuf};

use itertools::Itertools;

pub struct PathCleaner<'a> {
    crap: &'a [String],
    delimiter: &'a str,
}

impl<'a> PathCleaner<'a> {
    pub fn new(crap: &'a [String], delimiter: &'a str) -> Self {
        PathCleaner { crap, delimiter }
    }

    pub fn clean(&self, original_path: &'a Path) -> Result<PathBuf, String> {
        // Extract extension
        let ext = original_path.extension();
        let ext = match ext {
            Some(v) => v.to_str().unwrap().to_string(),
            None => String::new(),
        };

        if let Some(file_stem) = original_path.file_stem() {
            let file_stem = file_stem.to_str().unwrap().to_string();

            let mut new_stem = file_stem.clone();
            for c in self.crap {
                new_stem = new_stem.replace(c, "");
            }
            new_stem = new_stem.replace(".", " ");
            new_stem = new_stem
                .split_ascii_whitespace()
                .filter(|word| !word.is_empty())
                .join(self.delimiter);

            let new_path = original_path.with_file_name(new_stem).with_extension(ext);
            return Ok(new_path);
        } else {
            Err(format!("File Stem is empty for path: {:?}", original_path))
        }
    }
}
