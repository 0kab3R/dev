@echo off

SET /P url=Enter a URL:

streamlink %url% best --crunchyroll-username $username --crunchyroll-password $password

@echo on
