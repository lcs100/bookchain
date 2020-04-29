const debug = require("debug")("Main");
var Main = artifacts.require('../contracts/Main.sol');
var Web3 = require("web3");
var userIndex = {
  'userWeChat':0,
  'userPhone':1,
  'userEmail':2,
  'userAddress':3,
  'userCollection':4,
  'userBalance':5,
  'userName':6,
  'userETHAddress':7,
  'userId':8,
  'userCreateTime':9
}
var bookIndex = {
      "bookId":0,
      "bookName":1,
      "bookPictureUrl":2,
      "bookAppearance":3,
      "bookAppearanceDescription":4,
      "bookSubject":5,
      "bookMajor":6,
      "bookPrice":7,
      "bookCount":8,
      "bookProvince":9,
      "bookCity":10,
      "bookdistrict":11,
      "bookISBN":12,
      "bookAuthor":13,
      "bookPages":14,
      "bookPublisher":15,
      "bookOriginprice":16,
      "bookEdition":17,
      "bookDescription":18,
      "bookValid":19,
      "bookSeller":20,
      "bookCreateTime":21
}
contract("Main", function(accounts) {
    // This only runs once across all test suites
    var user0 = accounts[0];
    const eq = assert.equal.bind(assert);
    async function deployContract() {
      // debug("deploying contract");
      main = await Main.deployed();
    }
  // input struct return array
  describe("UserTest", function() {
      before(deployContract);

      it("test Register", async function() {
        var user = new Object();
        user.userWeChat = "wechat"
        user.userName = "testuser"
        user.userPhone = "123"
        user.userEmail = "book@book.cn"
        user.userAddress = new Array()
        user.userCollection = new Array()
        user.userBalance = 0
        user.userId = 0
        user.userCreateTime = 0
        user.userETHAddress = user0
        await main.Register(user,{from:user0})
        var user = await main.GetUserByUserId(1)
        eq(user[userIndex.userName],'testuser')
      });

      it("test GetUserByUserETHAddress", async function() {
        var user = await main.GetUserByUserETHAddress(user0)
        eq(user[userIndex.userName],'testuser')
      });

      it("test ModifyUser", async function() {
        var user = await main.GetUserByUserId(1)
        user[userIndex.userBalance] = 12
        user[userIndex.userEmail] = "1rr@fgfg"
        user[userIndex.userAddress].push("add1")
        user[userIndex.userAddress].push("add2")
        await main.ModifyUser(user);
        user = await main.GetUserByUserId(1);
        eq(user[userIndex.userEmail],'1rr@fgfg')
      });
    });

    describe("BookTest",function(){
      it("test AddBook",async function(){
          var book = new Object();
          book.bookId = 0;
          book.bookName = "他改变了中国";
          book.bookPictureUrl = "url";
          book.bookAppearance = 0;
          book.bookAppearanceDescription = "一句话也不说";
          book.bookSubject = 2;
          book.bookMajor = 2;
          book.bookPrice = 123;
          book.bookCount = 1;
          book.bookProvince = "peking";
          book.bookCity = "haidian";
          book.bookdistrict = "pku";
          book.bookISBN = "gfgf";
          book.bookAuthor = "frtr";
          book.bookPages = 111;
          book.bookPublisher = "publisher";
          book.bookOriginPrice = 123;
          book.bookEdition = "origin";
          book.bookDescription = "ffgf";
          book.bookValid = true;
          book.bookSeller = 0;
          book.bookCreateTime = 0;
          await main.AddBook(book)
      });

      it("GetBookByBookId",async function(){
          var book = await main.GetBookByBookId(1);
          eq(book[bookIndex.bookName],"他改变了中国")
      });

      it("GetMultiBook",async function(){
        var bookId = [0,1]
        var res = await main.GetMultiBook(bookId);
        eq(res[0][bookIndex.bookName],"")
        eq(res[1][bookIndex.bookName],"他改变了中国")
      })

      it("ModifyBook",async function(){
        var book = await main.GetBookByBookId(1);
        book[bookIndex.bookName] = "ぁ";
        await main.ModifyBook(book);
        book = await main.GetBookByBookId(1);
        console.log(book.bookName)
        eq(book.bookName,"ぁ")
      })
    });
});