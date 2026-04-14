package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.Image
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sanghwiback.beckbucks.R

@Preview(showBackground = true)
@Composable
fun MainNewEventSection() {
    val scrollState = rememberScrollState(0)

    Column(Modifier.padding(horizontal = 20.dp)) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Text(text = "What's New",
                fontWeight = FontWeight.Bold, fontFamily = FontFamily.SansSerif, fontSize = 20.sp)
            Text(text = "See all",
                fontWeight = FontWeight.SemiBold, fontFamily = FontFamily.Serif, fontSize = 10.sp,
                color = Color.Green)
        }

        Row(Modifier.horizontalScroll(scrollState)) {
            whatsNewItems.forEach { item ->
                Column(Modifier.padding(end = 12.dp)) {
                    Image(
                        modifier = Modifier
                            .height(128.dp)
                            .aspectRatio(1.6f)
                            .padding(bottom = 12.dp)
                            .clip(RoundedCornerShape(8.dp)),
                        painter = painterResource(item.imageId),
                        contentDescription = item.title)
                    Text(modifier = Modifier.padding(bottom = 4.dp), text = item.title,
                        fontFamily = FontFamily.SansSerif, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                    Text(modifier = Modifier.padding(bottom = 4.dp), text = item.content,
                        fontFamily = FontFamily.Default, fontSize = 12.sp)
                }
            }
        }
    }
}

data class WhatsNewItem(val imageId: Int, val title: String, val content: String)

val whatsNewItems = listOf(
    WhatsNewItem(R.drawable.whats_new_1, "Spring Cherry Blossom Latte", "Enjoy the floral taste of\nspring in every sip."),
    WhatsNewItem(R.drawable.whats_new_2, "Cold Brew Oat Milk", "Smooth cold brew paired\nwith creamy oat milk."),
    WhatsNewItem(R.drawable.whats_new_3, "Matcha Frappuccino", "A refreshing blend of\nmatcha and cream."),
    WhatsNewItem(R.drawable.whats_new_4, "Caramel Cloud Macchiato", "Light and dreamy layers\nof caramel espresso."),
    WhatsNewItem(R.drawable.whats_new_5, "Mango Dragonfruit Lemonade", "Tropical flavors for a\nbright summer day."),
    WhatsNewItem(R.drawable.whats_new_6, "Pistachio Latte", "Rich and nutty pistachio\nwith velvety espresso."),
    WhatsNewItem(R.drawable.whats_new_7, "Brown Sugar Oat Shaken", "Shaken espresso with\nbrown sugar and oat milk."),
    WhatsNewItem(R.drawable.whats_new_8, "Vanilla Sweet Cream Cold Brew", "Bold cold brew topped\nwith sweet vanilla cream."),
    WhatsNewItem(R.drawable.whats_new_9, "Iced Toasted Vanilla Latte", "Toasty vanilla flavor\nover smooth iced espresso."),
    WhatsNewItem(R.drawable.whats_new_10, "Pumpkin Spice Latte", "The iconic fall favorite\nreturns with warm spices."),
    WhatsNewItem(R.drawable.whats_new_11, "Chestnut Praline Latte", "Sweet praline and chestnut\nfor a cozy winter treat."),
    WhatsNewItem(R.drawable.whats_new_12, "Peppermint Mocha", "Classic mocha meets cool\npeppermint for the holidays."),
    WhatsNewItem(R.drawable.whats_new_13, "Honey Oat Milk Latte", "Golden honey swirled into\na creamy oat milk latte."),
    WhatsNewItem(R.drawable.whats_new_14, "Iced Brown Sugar Latte", "Sweet brown sugar layered\nover chilled espresso."),
    WhatsNewItem(R.drawable.whats_new_15, "Strawberry Acai Lemonade", "Bright and fruity blend\nof strawberry and lemon."),
    WhatsNewItem(R.drawable.whats_new_16, "Lavender Oat Milk Latte", "Floral lavender infused\ninto silky oat milk."),
    WhatsNewItem(R.drawable.whats_new_17, "Coconut Milk Mocha Macchiato", "Rich mocha with a tropical\ncoconut milk twist."),
    WhatsNewItem(R.drawable.whats_new_18, "Iced Passion Tango Tea", "Vibrant herbal tea served\nover refreshing ice."),
    WhatsNewItem(R.drawable.whats_new_19, "Nitro Cold Brew", "Silky smooth nitrogen-infused\ncold brew, straight from tap."),
    WhatsNewItem(R.drawable.whats_new_20, "Reserve Clover Brewed Coffee", "Rare single-origin beans\nbrewed to perfection."),
)

