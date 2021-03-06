# Test Files

Test files for testing and verifying [FileId](https://github.com/DBHeise/fileid).

Adding a file here is a great way to get it covered by [FileId](https://github.com/DBHeise/fileid).

This repo uses git-lfs, all binary files in this repo must be handled by lfs. See more information on the [git-lfs wiki](https://github.com/git-lfs/git-lfs/wiki)

Pull requests are welcome so long as the meet the requirements.

Old and obscure file formats are appreciated.

## File Requirements

1. Must be created by submitter, or submitter has permissions to submit/make-public from the file creator.
2. Must not have malicious content. Content will be considered malicious if any of the following are met:
    * The file contains code/script that is not intended by the file format. (e.g. adding scripts or shellcode in the comments or whitespace, etc)
    * The file contains code/script that is indended by the file format, but it calls or executes other code. (e.g. having a DOC with a macro is ok as long as it doesn't fetch and run something else).
3. Must not be covered by an existing file. (should be a new file format, or a new feature of an existing file format)
4. Binary files (so pretty much all files here), MUST be handled by git-lfs. As the lfs implementation is handled by github, their restrictions and limitations also apply here (basically no files larger than 2 GiB)
