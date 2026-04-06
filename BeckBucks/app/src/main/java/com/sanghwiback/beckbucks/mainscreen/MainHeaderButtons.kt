package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Preview(showBackground = true)
@Composable
fun MainHeaderButtons(modifier: Modifier = Modifier.padding(bottom = 18.dp)) {
    val scrollState = rememberScrollState()
    val items = listOf("Gold", "Coupon", "Pay", "Buddy Pass")

    Row(
        modifier = modifier.horizontalScroll(scrollState),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Spacer(Modifier.width(20.dp))

        items.forEach { name ->
            val isBuddyPass = name == "Buddy Pass"

            OutlinedButton(
                onClick = {},
                modifier = Modifier.height(38.dp),
                shape = RoundedCornerShape(50),
                border = BorderStroke(
                    width = 1.5.dp,
                    color = if (isBuddyPass) StarbucksGreen else BorderDefault
                ),
                colors = ButtonDefaults.outlinedButtonColors(
                    containerColor = Color.White,
                    contentColor   = if (isBuddyPass) StarbucksGreen else TextPrimary
                ),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 0.dp)
            ) {
                Text(
                    text = name,
                    fontSize = 14.sp,
                    fontWeight = if (isBuddyPass) FontWeight.SemiBold else FontWeight.Medium
                )
            }
        }

        Spacer(Modifier.width(20.dp))
    }
}
