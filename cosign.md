### Gerate key

- Create a directory to save your cosign key. Run;

``bash 
mkdir cosign-key && cd cosign-key

- `cd` into `cosign-key` and generate cosign keys by running the following

```bash
cosign generate-key-pair
```
This will prompt you to put password. Enter password and remember not to forget the password. This password will be used to verify public key in the pipeline.

- 