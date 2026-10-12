# QloApps sandbox deployment

This is an isolated evaluation sandbox, not the QloApps demo property production booking site.
The QloApps 1.7.0 release archive contains the packaged web installer; the Git checkout
does not contain the production `install/` directory, so the image is built from the
official release archive rather than the working tree contents.

## Render resources

`render.yaml` defines a private MySQL 8 service and a web service in the Ohio region.
The app and MySQL data use persistent disks. This requires paid Render instances and
disks; the current Render workspace has no payment method, so this persistent Blueprint
cannot be provisioned yet. No production services are referenced or modified by it.

For a no-cost first look, `Dockerfile.single` packages QloApps and MariaDB in one free
web container and protects every page, including the installer, with HTTP Basic Auth.
Create it from this repository with Dockerfile path `deploy/Dockerfile.single`, context
`.`, and `SANDBOX_USER`/`SANDBOX_PASSWORD` environment variables. Its database and
uploaded files are ephemeral: use fictional data only, and expect state to disappear
when Render replaces the instance. This is for evaluation, not a production migration.

The initial QloApps installer opens on the web service URL. In the database step, use
the private host and credentials supplied by the `QLOAPPS_DB_*` Render environment
variables. After installing, remove or rename the public `/install` directory using
the documented QloApps post-install procedure, then create a separate admin account
and disable any demo accounts. Configure TLS through Render's generated HTTPS URL.

The paid Blueprint's persistent app disk stores QloApps config and user media (`config/settings.inc.php`,
`img`, `upload`, `download`); app files are copied from each built image at startup.
Changing QloApps versions should be treated as an explicit upgrade with a database
backup first. The included Dockerfile currently pins the upstream 1.7.0 release.

The public QloApps codebase and bundled modules have multiple licenses. Review
`LICENSE.md` and individual module license files before redistributing a modified image.
