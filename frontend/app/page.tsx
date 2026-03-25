import BenefitsSection from "@/app/components/BenefitsSection";
import FeaturettesSection from "@/app/components/FeaturettesSection";
import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import HomeMain from "./components/HomeMain";

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col text-slate-900">
      <Navbar />

      <main className="flex-1">
       <HomeMain />

        <BenefitsSection />
        <FeaturettesSection />
      </main>

      <Footer />
    </div>
  );
}
