enum MessageEnum { Text, Image, Video, Audio, Gif, CallSuccess, CallFailure }

// ✅ Extension for converting String to MessageEnum
extension MessageEnumExtension on MessageEnum {
  String toJson() {
    return name; // Returns 'Text', 'Image', 'Video', etc.
  }

  static MessageEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return MessageEnum.Text;
      case 'image':
        return MessageEnum.Image;
      case 'video':
        return MessageEnum.Video;
      case 'audio':
        return MessageEnum.Audio;
      case 'gif':
        return MessageEnum.Gif;
      case 'true':
        return MessageEnum.CallSuccess;
      case 'false':
        return MessageEnum.CallFailure;
      default:
        return MessageEnum.Text; // Default to text if unknown type
    }
  }
}
