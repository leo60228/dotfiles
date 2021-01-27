self: super: {
    mpd = (self.callPackage ../mpd {}).mpd;
}
