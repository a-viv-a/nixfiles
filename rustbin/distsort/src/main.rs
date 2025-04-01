use miette::{miette, Context, Error, IntoDiagnostic, Result};
use rayon::prelude::*;
use std::{
    env,
    io::{stdin, stdout, BufWriter, Write},
};
use strsim::levenshtein;

#[derive(Debug)]
enum Sort {
    Stable,
    Unstable,
}

impl TryFrom<String> for Sort {
    type Error = Error;

    fn try_from(value: String) -> Result<Self> {
        match value.as_str() {
            "stable" => Ok(Self::Stable),
            "unstable" => Ok(Self::Unstable),
            _ => Err(miette!(
                "invalid string '{value}', expected 'stable' or 'unstable'"
            )),
        }
    }
}

// lifted in large part from https://github.com/BrianHicks/similar-sort/blob/main/src/main.rs

fn main() -> Result<()> {
    let mut args = env::args().skip(1);
    let sort = args
        .next()
        .ok_or(miette!("expected stable/unstable as first arg"))?
        .try_into()
        .wrap_err("for first arg")?;

    let target = args.collect::<Vec<_>>().join(" ");

    let lines: Vec<String> = stdin()
        .lines()
        .filter_map(|l| l.ok())
        .collect::<Vec<String>>();

    let mut out = BufWriter::new(stdout());

    let mut distances: Vec<(usize, &String)> = lines
        .par_iter()
        .map(|candidate| (levenshtein(target.as_str(), candidate), candidate))
        .collect();

    match sort {
        Sort::Stable => distances.par_sort_by_key(|x| x.0),
        Sort::Unstable => distances.par_sort_unstable_by_key(|x| x.0),
    }

    for (_, candidate) in distances {
        writeln!(out, "{}", candidate)
            .into_diagnostic()
            .wrap_err("could not write to stdout")?;
    }

    out.flush()
        .into_diagnostic()
        .wrap_err("could not finish writing to stdout")?;

    Ok(())
}
