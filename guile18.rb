class Guile18 < Formula
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/guile/guile-1.8.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-1.8.8.tar.gz"
  sha256 "c3471fed2e72e5b04ad133bbaaf16369e8360283679bcf19800bc1b381024050"

  bottle do
    sha256 "f6cc7fc10e96c8a0f3f9995d553928e59c4cbb009ddc474cd9e4f46987b4a309" => :sierra
    sha256 "870763907c7b555f280cd68e816789490105318d5a5ff40f6ad4f463ce87cdb0" => :el_capitan
    sha256 "82b956361a7353c23e1b7109f7cf1b5f4bf3c723e47ffca9283688d67d339508" => :yosemite
  end

  revision 1

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on OS X --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<-EOS.undent
      (display "Hello World")
      (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
