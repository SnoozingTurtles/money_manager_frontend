import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

void main() {
  group('Amount', () {
    test('should return failure when amount is null', () {
      //arrange
      var amount = Amount("0000");

      //assert
      expect(amount.value.fold((l) => l, (r) => r),
          const matcher.TypeMatcher<Failure>());
    });

    test('should create title if validated', () {
      //arrange
      var amount = Amount("240");

      //assert
      expect(amount.value.fold((l) => l, (r) => r),
          const matcher.TypeMatcher<String>());
    });
  });

  group('Note',(){
    test('should return failure when note exceeds 150 characters',(){
      //arrange
      var str = "";
      for(int i = 0;i <= 150;i++){
        str+="1";
      }
      var note = Note(str);

      //assert
      expect(str.length,greaterThan(150));
      expect(note.value.fold((l)=>l,(r)=>r),const matcher.TypeMatcher<Failure>());
    });
    test('should create note if text is within 150 characters',(){
      //arrange
      var str = "";
      for(int i = 0;i < 149;i++){
        str+="1";
      }
      var note = Note(str);

      //assert
      expect(str.length,lessThan(150));
      expect(note.value.fold((l)=>l,(r)=>r),const matcher.TypeMatcher<String>());
    });
  });

  group('Category',(){
    test('should return failure when category exceeds 10 characters',(){
      //arrange
      var str = "";
      for(int i = 0;i <= 10;i++){
        str+="1";
      }
      var category = Category(str);

      //assert
      expect(str.length,greaterThan(10));
      expect(category.value.fold((l)=>l,(r)=>r),const matcher.TypeMatcher<Failure>());
    });
    test('should return failure when category exceeds is multiline',(){
      //arrange
      var str = "abc \n def";
      var category = Category(str);

      //assert
      expect(category.value.fold((l)=>l,(r)=>r),const matcher.TypeMatcher<Failure>());
    });
    test('should create category if text is within 10 characters and not multiline',(){
      //arrange
      var str = "";
      for(int i = 0;i < 9;i++){
        str+="1";
      }
      var category = Category(str);

      //assert
      expect(str.length,lessThan(10));
      expect(category.value.fold((l)=>l,(r)=>r),const matcher.TypeMatcher<String>());
    });
  });
}
