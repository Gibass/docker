Put your custom PHP `.ini` files here.

Example file: `10-upload.ini`

```ini
upload_max_filesize = 64M
post_max_size = 64M
```

These files are imported at container startup and loaded after the base image defaults.
