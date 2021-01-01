//
//  BankPayment.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 01.01.21.
//

import SwiftUI

struct BankPayment: View {
    
    @EnvironmentObject var paymentVM: PaymentViewModel

    
    var body: some View {
        WebView(url: "https://servicestest.ameriabank.am/VPOS/Payments/Pay?id=\(self.paymentVM.paymentID)")
    }
}

struct BankPayment_Previews: PreviewProvider {
    static var previews: some View {
        BankPayment()
    }
}
