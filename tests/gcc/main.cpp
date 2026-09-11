#include <boost/version.hpp>
#include <gtest/gtest.h>
#include <openssl/opensslv.h>

TEST(GccDevshell, Arithmetic)
{
    EXPECT_EQ(2 + 2, 4);
}

TEST(GccDevshell, BoostAndOpensslHeadersAvailable)
{
    EXPECT_GT(BOOST_VERSION, 0);
    EXPECT_GT(OPENSSL_VERSION_NUMBER, 0);
}
