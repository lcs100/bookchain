pragma experimental ABIEncoderV2;

contract Main {
   struct Book {
       uint256 bookId;
       string bookName;
       string bookPictureUrl;
       uint256 bookAppearance;
       string bookAppearanceDescription;
       uint256 bookSubject;
       uint256 bookMajor;
       uint256 bookPrice;
       uint256 bookCount;
       string bookProvince;
       string bookCity;
       string bookdistrict;
       string bookISBN;
       string bookAuthor;
       uint256 bookPages;
       string bookPublisher;
       uint256 bookOriginPrice;
       string bookEdition;
       string bookDescription;
       bool    bookValid;
       uint256 bookSeller;
       uint256 bookCreateTime;
   }

   struct User {
       string userWeChat;
       string userPhone;
       string userEmail;
       string[] userAddress;
       uint[] userCollection;
       uint userBalance;
       string userName;
       address userETHAddress;
       uint256 userId;
       uint256 userCreateTime;
   }

   struct Order {
       uint256 orderId;
       uint256 orderBookId;
       uint256 orderSellerId;
       uint256 orderBuyerId;
       uint256 orderCreatetime;
       uint256 orderState;//0：待确认 1：交易成功 3：卖方取消 4：买方取消
       uint256 orderFinishTime;
       uint256 orderCancelReason;
    }
    User[] userList;
    mapping(string=>uint256) userWeChatToUserId;
    mapping(address=>uint256) userETHAddressToUserId;

    Book[] bookList;
    
    Order[] orderList;
    mapping(uint256=>uint256) orderBookIdToOrderId;
    mapping(uint256=>uint256[]) orderSellerIdToOrderId;
    mapping(uint256=>uint256[]) orderBuyerIdToOrderId;

    constructor() public {
        string[] memory userAddress;
        uint256[] memory userCollection;
        User memory user = User("","","",userAddress,userCollection,0,"",msg.sender,0,0);
        user.userETHAddress = msg.sender;
        Register(user);

        Book memory book = Book(0,"","",0,"",0,0,0,0,"","","","","",0,"",0,"","",true,0,now);
        AddBook(book);
    }
    /**
        User CRUD
     */
    function Register(User memory _user) public {
        User memory user = _user;
        user.userId = userList.length;
        user.userETHAddress = msg.sender;
        user.userCreateTime = block.timestamp;
        userList.push(user);
        userWeChatToUserId[user.userWeChat] = userList.length-1;
        userETHAddressToUserId[msg.sender] = userList.length-1;
    }

    function GetUserByUserETHAddress(address _userETHAddress) public view returns(User memory){
        return GetUserByUserId(userETHAddressToUserId[_userETHAddress]);
    }

    function GetUserByUserId(uint256 _userId) public view returns(User memory){
        return userList[_userId];
    }

    function ModifyUser(User memory _user) public returns(string memory){
        userList[_user.userId] = _user;
    }

    /**
        Book Crud
     */
    function AddBook(Book memory _book) public {
        Book memory book = _book;
        book.bookId = bookList.length;
        book.bookCreateTime = block.timestamp;
        bookList.push(book);
    }

    function GetBookByBookId(uint256 bookId) public view returns(Book memory) {
        return bookList[bookId];
    }
    
    function ModifyBook(Book memory _book) public {
        bookList[_book.bookId] = _book;
    }

    function GetMultiBook(uint256[] memory _bookId) public view returns(Book[]memory){
        Book[] memory res = new Book[](_bookId.length);
        for(uint256 i = 0; i<_bookId.length; i++) {
            res[i] = bookList[_bookId[i]];
        }
        return res;
    }

    /**
     Order curd
     */
    function AddOrder(Order memory _order) public {
        Order memory order = _order;
        order.orderId = orderList.length;
        order.orderCreatetime = block.timestamp;
        orderList.push(order);
        orderBookIdToOrderId[order.orderBookId] = order.orderId;
        orderSellerIdToOrderId[order.orderSellerId].push(order.orderId);
        orderBuyerIdToOrderId[order.orderBuyerId].push(order.orderId);
    }

    function GetMultiOrder(uint256[] memory _orderId) public view returns(Order[] memory) {
        Order[] memory res = new Order[](_orderId.length);
        for(uint256 i = 0; i<_orderId.length; i++) {
            res[i] = orderList[_orderId[i]];
        }
        return res;
    }

    function GetMyBuyerOrder() public view returns(Order[] memory){
        return GetMultiOrder(orderBuyerIdToOrderId[userETHAddressToUserId[msg.sender]]);
    }

    function GetMySellerOrder() public view returns(Order[] memory){
        return GetMultiOrder(orderSellerIdToOrderId[userETHAddressToUserId[msg.sender]]);
    }

    function ModiyOrder(Order memory _order) public{
        orderList[_order.orderId] = _order;
    }
}