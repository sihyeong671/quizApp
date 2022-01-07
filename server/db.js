import UserModel from "./model/users.js";

function add(name, image, callback) {
    const newUser = new UserModel({
        nickName: name, img: image
    });
    newUser.save((error, result) => {
        callback(result);
    })
}

export default {
    add
}